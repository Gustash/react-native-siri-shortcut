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
    
    var _editingVoiceShortcut: NSObject? // Keep support for iOS <9
    @available(iOS 12.0, *)
    var editingVoiceShortcut: INVoiceShortcut? {
        get {
            _editingVoiceShortcut as? INVoiceShortcut
        }
        set {
           _editingVoiceShortcut = newValue
        }
    }
    var presenterViewController: UIViewController?
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startedFromShortcut(notification:)),
            name: NSNotification.Name(rawValue: "InitialUserActivity"),
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
                            rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
        self.fetchRecorderdVoiceShortcuts { voiceShortcuts, error in
            if let error = error {
                reject("get_shortcuts_failure", error.localizedDescription, error)
                return
            }
            
            if let voiceShortcuts = voiceShortcuts {
                let result = voiceShortcuts.map { voiceShortcut -> [String: Any?] in
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
                }
                resolve(result)
                return
            }
            
            reject("get_shortcuts_failure", "An unknown error has occurred. Please open an issue on GitHub.", nil)
        }
    }
    
    @available(iOS 12.0, *)
    @objc func presentShortcut(_ jsonOptions: Dictionary<String, Any>, callback: @escaping RCTResponseSenderBlock) {
        let activity = ShortcutsModule.generateUserActivity(jsonOptions)

        let shortcut = INShortcut(userActivity: activity)
        
        self.fetchRecorderdVoiceShortcuts { voiceShortcuts, error in
            guard let voiceShortcuts = voiceShortcuts else {
                if let error = error {
                    callback([["status": VoiceShortcutMutationStatus.cancelled.rawValue,
                               "error": "failed to fetch recorded shortcuts: \(error)"]])
                    return
                }
                callback([["status": VoiceShortcutMutationStatus.cancelled.rawValue,
                           "error": "unknown error fetching recorded shortcuts"]])
                return
            }

            self.presentShortcutCallback = callback
            let addedVoiceShortcut = voiceShortcuts.first { (voiceShortcut) -> Bool in
              if let userActivity = voiceShortcut.shortcut.userActivity, userActivity.activityType == activity.activityType {
                return true
              }
              return false
            }

            DispatchQueue.main.async {
                if let addedVoiceShortcut = addedVoiceShortcut {
                    // The shortcut was already added, so we present a form to edit it
                    self.editingVoiceShortcut = addedVoiceShortcut
                    let presenterViewController = INUIEditVoiceShortcutViewController(voiceShortcut: addedVoiceShortcut)
                    presenterViewController.modalPresentationStyle = .formSheet
                    presenterViewController.delegate = self
                    self.presenterViewController = presenterViewController
                } else {
                    // The shortcut was not added yet, so present a form to add it
                    let presenterViewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
                    presenterViewController.modalPresentationStyle = .formSheet
                    presenterViewController.delegate = self
                    self.presenterViewController = presenterViewController
                }

                UIApplication.shared.keyWindow!.rootViewController!.present(self.presenterViewController!, animated: true, completion: nil)
            }
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
    public func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                               didFinishWith voiceShortcut: INVoiceShortcut?,
                                               error: Error?)
    {
        // Shortcut was added
        dismissPresenter(.added, withShortcut: voiceShortcut)
    }
    
    @available(iOS 12.0, *)
    public func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        // Adding shortcut cancelled
        dismissPresenter(.cancelled, withShortcut: nil)
    }
    
    @available(iOS 12.0, *)
    public func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                                didUpdate voiceShortcut: INVoiceShortcut?,
                                                error: Error?)
    {
        // Shortcut was updated
        dismissPresenter(.updated, withShortcut: voiceShortcut)
        self.editingVoiceShortcut = nil
    }
    
    @available(iOS 12.0, *)
    public func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                                didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        // Shortcut was deleted
        guard let editingVoiceShortcut = self.editingVoiceShortcut else {
            print("Could not find shortcut being edited.")
            dismissPresenter(.deleted, withShortcut: nil)
            return
        }
        dismissPresenter(.deleted, withShortcut: editingVoiceShortcut)
        self.editingVoiceShortcut = nil
    }
    
    @available(iOS 12.0, *)
    public func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        // Shortcut edit was cancelled
        dismissPresenter(.cancelled, withShortcut: nil)
        self.editingVoiceShortcut = nil
    }

    @available(iOS 12.0, *)
    func fetchRecorderdVoiceShortcuts(completion: @escaping ([INVoiceShortcut]?, Error?) -> Void) {
        // Get all added voice shortcuts so we can make sure later if the presented shortcut is to be edited or added
        INVoiceShortcutCenter.shared.getAllVoiceShortcuts  { (voiceShortcutsFromCenter, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            if let voiceShortcutsFromCenter = voiceShortcutsFromCenter {
                completion(voiceShortcutsFromCenter, nil)
                return
            }

            completion(nil, nil)
        }
    }
    
    // become current
    // resign current
    // invalidate
    
}
