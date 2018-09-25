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
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startedFromShortcut(notification:)), name: NSNotification.Name(rawValue: "InitialUserActivity"), object: nil)
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func supportedEvents() -> [String]! {
        return ["SiriShortcutListener"]
    }
    
    @objc func startedFromShortcut(notification: NSNotification) {
        sendEvent(withName: "SiriShortcutListener", body: [
            "userInfo": notification.userInfo
            ])
    }
    
    @available(iOS 12.0, *)
    @objc func setupShortcut(_ jsonOptions: Dictionary<String, Any>) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let options = ShortcutOptions(jsonOptions)
            print("Options: \(options)")
            
            let activity = NSUserActivity(activityType: options.activityType)
            activity.title = options.title
            activity.requiredUserInfoKeys = options.requiredUserInfoKeys
            activity.userInfo = options.userInfo
            activity.needsSave = options.needsSave
            activity.keywords = Set(options.keywords ?? [])
            if let identifier = options.persistentIdentifier {
                activity.persistentIdentifier = NSUserActivityPersistentIdentifier(identifier)
            }
            activity.isEligibleForHandoff = options.isEligibleForHandoff
            activity.isEligibleForSearch = options.isEligibleForSearch
            activity.isEligibleForPublicIndexing = options.isEligibleForPublicIndexing
            activity.expirationDate = options.expirationDate
            if let urlString = options.webpageURL {
                activity.webpageURL = URL(string: urlString)
            }
            activity.isEligibleForPrediction = options.isEligibleForPrediction
            activity.suggestedInvocationPhrase = options.suggestedInvocationPhrase
            
            topController.userActivity = activity
            activity.becomeCurrent()
            print("Just created shortcut")
        }
    }
    
    // become current
    // resign current
    // invalidate
    // delete all saved user activities
    // delete saved user activities
    
}
