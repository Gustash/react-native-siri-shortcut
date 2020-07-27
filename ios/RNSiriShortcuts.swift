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
import CoreSpotlight

enum VoiceShortcutMutationStatus: String {
    case cancelled = "cancelled"
    case added = "added"
    case updated = "updated"
    case deleted = "deleted"
}

@objc(ShortcutsModule)
open class ShortcutsModule: RCTEventEmitter, INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
    var hasListeners: Bool = false
    
    var presenterViewController: UIViewController?
    var voiceShortcuts: Array<NSObject> = [] // Actually it's INVoiceShortcut, but that way we would have to break compatibility with simple NSUserActivity behaviour
    var presentShortcutCallback: RCTResponseSenderBlock?
    @objc public static var initialUserActivity: NSUserActivity?
    
    @objc public static func onShortcutReceived(userActivity: NSUserActivity) {
        let userInfo = userActivity.userInfo
        let activityType = userActivity.activityType
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InitialUserActivity"), object: nil, userInfo: [
            "userInfo": userInfo as Any,
            "activityType": activityType
            ])
    }
    
    override init() {
        
        super.init()
        
        syncVoiceShortcuts()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startedFromShortcut(notification:)),
            name: NSNotification.Name(rawValue: "InitialUserActivity"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appMovedToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override open func startObserving() {
        hasListeners = true
        
        if let userActivity = ShortcutsModule.initialUserActivity {
            ShortcutsModule.onShortcutReceived(userActivity: userActivity)
            ShortcutsModule.initialUserActivity = nil
        }
    }
    
    override open func stopObserving() {
        hasListeners = false
    }
    
    override static public func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override open func supportedEvents() -> [String]! {
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
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: options.contentType as String)
        if let description = options.contentDescription {
            attributes.contentDescription = description
        }
        activity.contentAttributeSet = attributes
        
        return activity
    }
    
    @available(iOS 9.0, *)
    @objc func donateShortcut(_ jsonOptions: Dictionary<String, Any>) {
        let activity = ShortcutsModule.generateUserActivity(jsonOptions)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow!.rootViewController!.userActivity = activity
        }
        activity.becomeCurrent()
    }
    
    @available(iOS 12.0, *)
    @objc func suggestShortcuts(_ jsonArray: Array<Dictionary<String, Any>>) {
        let suggestions = jsonArray.map { (_ options) -> INShortcut in
            let activity = ShortcutsModule.generateUserActivity(options)
            return INShortcut(userActivity: activity)
        }
        
        // Suggest the shortcuts.
        INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
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
    @objc func getShortcuts(_ resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: RCTPromiseRejectBlock) -> Void {
        resolve((voiceShortcuts as! Array<INVoiceShortcut>).map({ (voiceShortcut) -> [String: Any?] in
            var options: [String: Any?]? = nil
            if let userActivity = voiceShortcut.shortcut.userActivity {
                options = [
                    "activityType": userActivity.activityType,
                    "title": userActivity.title,
                    "requiredUserInfoKeys": userActivity.requiredUserInfoKeys,
                    "userInfo": userActivity.userInfo,
                    "needsSave": userActivity.needsSave,
                    "keywords": userActivity.keywords,
                    "persistentIndentifier": userActivity.persistentIdentifier,
                    "isEligibleForHandoff": userActivity.isEligibleForHandoff,
                    "isEligibleForSearch": userActivity.isEligibleForSearch,
                    "isEligibleForPublicIndexing": userActivity.isEligibleForPublicIndexing,
                    "expirationDate": userActivity.expirationDate,
                    "webpageURL": userActivity.webpageURL,
                    "isEligibleForPrediction": userActivity.isEligibleForPrediction,
                    "suggestedInvocationPhrase": userActivity.suggestedInvocationPhrase
                ]
            }
            
            return [
                "identifier": voiceShortcut.identifier.uuidString,
                "phrase": voiceShortcut.invocationPhrase,
                "options": options
            ]
        }))
    }
    
    @available(iOS 12.0, *)
    @objc func presentShortcut(_ jsonOptions: Dictionary<String, Any>, callback: @escaping RCTResponseSenderBlock) {
        self.presentShortcutCallback = callback
        let activity = ShortcutsModule.generateUserActivity(jsonOptions)

        let shortcut = INShortcut(userActivity: activity)

        // To preserve compatilibility with iOS >9.0, the array contains NSObjects, so we need to convert here
        let addedVoiceShortcut = (self.voiceShortcuts as! Array<INVoiceShortcut>).first { (voiceShortcut) -> Bool in
          if let userActivity = voiceShortcut.shortcut.userActivity, userActivity.activityType == activity.activityType {
            return true
          }
          return false
        }

      DispatchQueue.main.async {
        // The shortcut was not added yet, so present a form to add it
        if (addedVoiceShortcut == nil) {
          self.presenterViewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
          self.presenterViewController!.modalPresentationStyle = .formSheet
          (self.presenterViewController as! INUIAddVoiceShortcutViewController).delegate = self
        } // The shortcut was already added, so we present a form to edit it
        else {
          self.presenterViewController = INUIEditVoiceShortcutViewController(voiceShortcut: addedVoiceShortcut!)
          self.presenterViewController!.modalPresentationStyle = .formSheet
          (self.presenterViewController as! INUIEditVoiceShortcutViewController).delegate = self
        }

        UIApplication.shared.keyWindow!.rootViewController!.present(self.presenterViewController!, animated: true, completion: nil)
      }
    }

    @available(iOS 12.0, *)
    func dismissPresenter(_ status: VoiceShortcutMutationStatus, withShortcut voiceShortcut: INVoiceShortcut?) {
      DispatchQueue.main.async {
        self.presenterViewController?.dismiss(animated: true, completion: nil)
        self.presenterViewController = nil
        self.presentShortcutCallback?([
          ["status": status.rawValue, "phrase": voiceShortcut?.invocationPhrase]
        ])
        self.presentShortcutCallback = nil
      }
    }
    
    @available(iOS 12.0, *)
    public func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        // Shortcut was added
        if (voiceShortcut != nil) {
            voiceShortcuts.append(voiceShortcut!)
        }
        dismissPresenter(.added, withShortcut: voiceShortcut)
    }
    
    @available(iOS 12.0, *)
    public func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        // Adding shortcut cancelled
        dismissPresenter(.cancelled, withShortcut: nil)
    }
    
    @available(iOS 12.0, *)
    public func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
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
        
        dismissPresenter(.updated, withShortcut: voiceShortcut)
    }
    
    @available(iOS 12.0, *)
    public func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        // Shortcut was deleted
        
        // Keep a reference so we can notify JS about what the invocationPhrase was for this shortcut
        var deletedShortcut: INVoiceShortcut? = nil
        
        // Remove the deleted shortcut from the array
        let indexOfDeletedShortcut = (voiceShortcuts as! Array<INVoiceShortcut>).firstIndex { (shortcut) -> Bool in
            return shortcut.identifier == deletedVoiceShortcutIdentifier
        }
        
        if (indexOfDeletedShortcut != nil) {
            deletedShortcut = voiceShortcuts[indexOfDeletedShortcut!] as? INVoiceShortcut
            voiceShortcuts.remove(at: indexOfDeletedShortcut!)
        }
        
        dismissPresenter(.deleted, withShortcut: deletedShortcut)
    }
    
    @available(iOS 12.0, *)
    public func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        // Shortcut edit was cancelled
        dismissPresenter(.cancelled, withShortcut: nil)
    }

    func syncVoiceShortcuts() {
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
    }

    @objc func appMovedToForeground() {
        syncVoiceShortcuts()
    }
    
    // become current
    // resign current
    // invalidate
    
}
