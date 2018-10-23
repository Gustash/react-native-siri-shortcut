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

@objc(ShortcutsModule)
class ShortcutsModule: RCTEventEmitter {
    var hasListeners: Bool = false
    let rootViewController: UIViewController
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
        self.rootViewController = UIApplication.shared.keyWindow!.rootViewController!
        
        super.init()
        
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
    @objc func donateShortcut(_ jsonOptions: Dictionary<String, Any>) {
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
        
        self.rootViewController.userActivity = activity
        activity.becomeCurrent()
        print("Just created shortcut")
    }
    
    @available(iOS 12.0, *)
    @objc func suggestShortcuts(_ jsonArray: Array<Dictionary<String, Any>>) {
        var suggestions = [] as [INShortcut]
        
        for jsonOption in jsonArray {
            let option = ShortcutOptions(jsonOption)
            
            let activity = NSUserActivity(activityType: option.activityType)
            activity.title = option.title
            activity.requiredUserInfoKeys = option.requiredUserInfoKeys
            activity.userInfo = option.userInfo
            activity.needsSave = option.needsSave
            activity.keywords = Set(option.keywords ?? [])
            activity.isEligibleForHandoff = option.isEligibleForHandoff
            activity.isEligibleForSearch = option.isEligibleForSearch
            activity.isEligibleForPublicIndexing = option.isEligibleForPublicIndexing
            activity.expirationDate = option.expirationDate
            if let urlString = option.webpageURL {
                activity.webpageURL = URL(string: urlString)
            }
            
            activity.isEligibleForPrediction = option.isEligibleForPrediction
            activity.suggestedInvocationPhrase = option.suggestedInvocationPhrase
            if let identifier = option.persistentIdentifier {
                activity.persistentIdentifier = NSUserActivityPersistentIdentifier(identifier)
            }
            
            suggestions.append(INShortcut(userActivity: activity))
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
    
    // become current
    // resign current
    // invalidate
    
}
