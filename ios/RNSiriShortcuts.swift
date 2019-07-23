//
//  ShortcutsModule.swift
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 23/09/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import UIKit
import Intents
import IntentsUI

enum VoiceShortcutMutationStatus: String {
    case cancelled = "cancelled"
    case added = "added"
    case updated = "updated"
    case deleted = "deleted"
}

@objc(ShortcutsModule)
class ShortcutsModule: RCTEventEmitter, INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
    var hasListeners: Bool = false

    var presenterViewController: UIViewController?
    var voiceShortcuts: Array<NSObject> = [] // Actually it's INVoiceShortcut, but that way we would have to break compatibility with simple NSUserActivity behaviour
    var presentShortcutCallback: RCTResponseSenderBlock?
    @objc static var initialUserActivity: NSUserActivity?
    
    @objc static func onShortcutReceived(userActivity: NSUserActivity) {
        let userInfo = userActivity.userInfo
        let activityType = userActivity.activityType
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InitialUserActivity"), object: nil, userInfo: [
            "userInfo": userInfo as Any,
            "activityType": activityType
            ])
    }
    
    override init() {
      
        super.init()
        
        // Get all added voice shortcuts so we can make sure later if the presented shortcut is to be edited or added
        if #available(iOS 12.0, *) {
            INVoiceShortcutCenter.shared.getAllVoiceShortcuts  { (voiceShortcutsFromCenter, error) in
                guard let voiceShortcutsFromCenter = voiceShortcutsFromCenter else {
                    if let error = error as NSError? {
                        NSLog("Failed to fetch voice shortcuts with error: \(error.userInfo)")
                    }
                    return
                }
                self.voiceShortcuts = voiceShortcutsFromCenter
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startedFromShortcut(notification:)),
            name: NSNotification.Name(rawValue: "InitialUserActivity"),
            object: nil
        )
    }
    
    override func startObserving() {
        hasListeners = true
        
        if let userActivity = ShortcutsModule.initialUserActivity {
            ShortcutsModule.onShortcutReceived(userActivity: userActivity)
            ShortcutsModule.initialUserActivity = nil
        }
    }
    
    override func stopObserving() {
        hasListeners = false
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func supportedEvents() -> [String]! {
        return ["SiriShortcutListener"]
    }
    
    @objc func startedFromShortcut(notification: NSNotification) {
        let userInfo = notification.userInfo?["userInfo"]
        let activityType = notification.userInfo?["activityType"]
        
        if (hasListeners) {
            sendEvent(withName: "SiriShortcutListener", body: [
                "userInfo": userInfo,
                "activityType": activityType
                ])
        }
    }
    
    @available(iOS 9.0, *)
    static func generateUserActivity(_ jsonOptions: Dictionary<String, Any>) -> NSUserActivity {
        let options = ShortcutOptions(jsonOptions)
        
        let activity = NSUserActivity(activityType: options.activityType)
        activity.title = options.title
        activity.requiredUserInfoKeys = options.requiredUserInfoKeys
        activity.userInfo = options.userInfo
        activity.needsSave = options.needsSave
        activity.keywords = Set(options.keywords ?? [])
        activity.isEligibleForHandoff = options.isEligibleForHandoff
        activity.isEligibleForSearch = options.isEligibleForSearch
        activity.isEligibleForPublicIndexing = options.isEligibleForPublicIndexing
        activity.expirationDate = options.expirationDate
        if let urlString = options.webpageURL {
            activity.webpageURL = URL(string: urlString)
        }
        
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = options.isEligibleForPrediction
            activity.suggestedInvocationPhrase = options.suggestedInvocationPhrase
            if let identifier = options.persistentIdentifier {
                activity.persistentIdentifier = NSUserActivityPersistentIdentifier(identifier)
            }
        }
        
        return activity
    }
    
    @available(iOS 9.0, *)
    @objc func donateShortcut(_ jsonOptions: Dictionary<String, Any>) {
        let activity = ShortcutsModule.generateUserActivity(jsonOptions)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow!.rootViewController!.userActivity = activity
        }
        activity.becomeCurrent()
        print("Just created shortcut")
    }
    
    @available(iOS 12.0, *)
    @objc func suggestShortcuts(_ jsonArray: Array<Dictionary<String, Any>>) {
        let suggestions = jsonArray.map { (_ options) -> INShortcut in
            let activity = ShortcutsModule.generateUserActivity(options)
            return INShortcut(userActivity: activity)
        }
        
        // Suggest the shortcuts.
        INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
        print("Created suggested shortcuts")
    }
    
    @objc func clearAllShortcuts(_ resolve: @escaping RCTPromiseResolveBlock,
                                 rejecter reject: RCTPromiseRejectBlock) -> Void {
        if #available(iOS 12.0, *) {
            NSUserActivity.deleteAllSavedUserActivities {
                resolve(nil)
            }
        } else {
            reject("below_ios_12", "Your device needs to be running iOS 12+ for this", nil)
        }
    }
    
    @objc func clearShortcutsWithIdentifiers(_ persistentIdentifiers: Array<String>,
                                             resolver resolve: @escaping RCTPromiseResolveBlock,
                                             rejecter reject: RCTPromiseRejectBlock) -> Void {
        if #available(iOS 12.0, *) {
            let persistentIdentifierArr = persistentIdentifiers.map {
                NSUserActivityPersistentIdentifier($0)
            }
            
            NSUserActivity.deleteSavedUserActivities(withPersistentIdentifiers: persistentIdentifierArr,
                                                     completionHandler: { resolve(nil) })
        } else {
            reject("below_ios_12", "Your device needs to be running iOS 12+ for this", nil)
        }
    }
    
    @available(iOS 12.0, *)
    @objc func presentShortcut(_ jsonOptions: Dictionary<String, Any>, callback: @escaping RCTResponseSenderBlock) {
        presentShortcutCallback = callback
        let activity = ShortcutsModule.generateUserActivity(jsonOptions)
        
        let shortcut = INShortcut(userActivity: activity)
        
        // To preserve compatilibility with iOS >9.0, the array contains NSObjects, so we need to convert here
        let addedVoiceShortcut = (voiceShortcuts as! Array<INVoiceShortcut>).first { (voiceShortcut) -> Bool in
            if let userActivity = voiceShortcut.shortcut.userActivity, userActivity.activityType == activity.activityType {
                return true
            }
            return false
        }
        
        // The shortcut was not added yet, so present a form to add it
        if (addedVoiceShortcut == nil) {
            presenterViewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            presenterViewController!.modalPresentationStyle = .formSheet
            (presenterViewController as! INUIAddVoiceShortcutViewController).delegate = self
        } // The shortcut was already added, so we present a form to edit it
        else {
            presenterViewController = INUIEditVoiceShortcutViewController(voiceShortcut: addedVoiceShortcut!)
            presenterViewController!.modalPresentationStyle = .formSheet
            (presenterViewController as! INUIEditVoiceShortcutViewController).delegate = self
        }
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow!.rootViewController!.present(self.presenterViewController!, animated: true, completion: nil)
        }
    }
    
    func dismissPresenter(_ status: VoiceShortcutMutationStatus) {
        presenterViewController?.dismiss(animated: true, completion: nil)
        presenterViewController = nil
        presentShortcutCallback?([
            ["status": status.rawValue]
            ])
        presentShortcutCallback = nil
    }
    
    @available(iOS 12.0, *)
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        // Shortcut was added
        if (voiceShortcut != nil) {
            voiceShortcuts.append(voiceShortcut!)
        }
        dismissPresenter(.added)
    }
    
    @available(iOS 12.0, *)
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        // Adding shortcut cancelled
        dismissPresenter(.cancelled)
    }
    
    @available(iOS 12.0, *)
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        // Shortcut was updated
        
        if (voiceShortcut != nil) {
            // Update the array with the shortcut that was updated, just so we don't have to loop over the existing shortcuts again
            let indexOfUpdatedShortcut = (voiceShortcuts as! Array<INVoiceShortcut>).firstIndex { (shortcut) -> Bool in
                return shortcut.identifier == voiceShortcut!.identifier
            }
            
            if (indexOfUpdatedShortcut != nil) {
                voiceShortcuts[indexOfUpdatedShortcut!] = voiceShortcut!
            }
        }
        
        dismissPresenter(.updated)
    }
    
    @available(iOS 12.0, *)
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        // Shortcut was deleted
        
        // Remove the deleted shortcut from the array
        let indexOfDeletedShortcut = (voiceShortcuts as! Array<INVoiceShortcut>).firstIndex { (shortcut) -> Bool in
            return shortcut.identifier == deletedVoiceShortcutIdentifier
        }
        
        if (indexOfDeletedShortcut != nil) {
            voiceShortcuts.remove(at: indexOfDeletedShortcut!)
        }
        
        dismissPresenter(.deleted)
    }
    
    @available(iOS 12.0, *)
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        // Shortcut edit was cancelled
        dismissPresenter(.cancelled)
    }
    
    // become current
    // resign current
    // invalidate
    
}
