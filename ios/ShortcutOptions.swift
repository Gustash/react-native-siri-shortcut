//
//  ShortcutOptions.swift
//  SiriShortcutsExample
//
//  Created by Gustavo Parreira on 23/09/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import MobileCoreServices

class ShortcutOptions: NSObject {
    let activityType: String
    let title: String?
    let requiredUserInfoKeys: Set<String>?
    let userInfo: [AnyHashable : Any]?
    let needsSave: Bool
    let keywords: Array<String>?
    let persistentIdentifier: String?
    let isEligibleForHandoff: Bool
    let isEligibleForSearch: Bool
    let isEligibleForPublicIndexing: Bool
    let expirationDate: Date?
    let webpageURL: String?
    let isEligibleForPrediction: Bool
    let suggestedInvocationPhrase: String?
    let contentDescription: String?
    let contentType: CFString
    
    init(_ json: Dictionary<String, Any>) {
        self.activityType = RCTConvert.nsString(json["activityType"])
        
        if let title = json["title"] as? String {
            self.title = RCTConvert.nsString(title)
        } else {
            self.title = nil
        }
        
        if let requiredUserInfoKeys = json["requiredUserInfoKeys"] {
            self.requiredUserInfoKeys = RCTConvert.nsSet(requiredUserInfoKeys) as? Set<String>
        } else {
            self.requiredUserInfoKeys = nil
        }
        
        if let userInfo = json["userInfo"] {
            self.userInfo = RCTConvert.nsDictionary(userInfo)
        } else {
            self.userInfo = nil
        }
        
        if let keywords = json["keywords"] {
            self.keywords = RCTConvert.nsStringArray(keywords)
        } else {
            self.keywords = nil
        }
        
        if let persistentIdentifier = json["persistentIdentifier"] {
            self.persistentIdentifier = RCTConvert.nsString(persistentIdentifier)
        } else {
            self.persistentIdentifier = nil
        }
        
        if let expirationDate = json["expirationDate"] {
            self.expirationDate = RCTConvert.nsDate(expirationDate)
        } else {
            self.expirationDate = nil
        }
        
        if let webpageURL = json["webpageURL"] as? String {
            self.webpageURL = RCTConvert.nsString(webpageURL)
        } else {
            self.webpageURL = nil
        }
        
        if let suggestedInvocationPhrase = json["suggestedInvocationPhrase"] as? String {
            self.suggestedInvocationPhrase = RCTConvert.nsString(suggestedInvocationPhrase)
        } else {
            self.suggestedInvocationPhrase = nil
        }
        
        if let needsSave = json["needsSave"] {
            self.needsSave = RCTConvert.bool(needsSave)
        } else {
            self.needsSave = false
        }
        
        if let isEligibleForHandoff = json["isEligibleForHandoff"] {
            self.isEligibleForHandoff = RCTConvert.bool(isEligibleForHandoff)
        } else {
            self.isEligibleForHandoff = true
        }
        
        if let isEligibleForSearch = json["isEligibleForSearch"] {
            self.isEligibleForSearch = RCTConvert.bool(isEligibleForSearch)
        } else {
            self.isEligibleForSearch = false
        }
        
        if let isEligibleForPublicIndexing = json["isEligibleForPublicIndexing"]  {
            self.isEligibleForPublicIndexing = RCTConvert.bool(isEligibleForPublicIndexing)
        } else {
            self.isEligibleForPublicIndexing = false
        }
        
        if let isEligibleForPrediction = json["isEligibleForPrediction"] {
            self.isEligibleForPrediction = RCTConvert.bool(isEligibleForPrediction)
        } else {
            self.isEligibleForPrediction = false
        }
        
        if let description = json["description"] {
            self.contentDescription = RCTConvert.nsString(description);
        } else {
            self.contentDescription = nil
        }
        
        if let contentType = json["contentType"] {
            self.contentType = RCTConvert.nsString(contentType) as CFString
        } else {
            self.contentType = kUTTypeItem
        }
    }
    
    override var description: String {
        return "activityType: \(self.activityType), title: \(String(describing: self.title)), requiredUserInfoKeys: \(String(describing: requiredUserInfoKeys)), userInfo: \(String(describing: self.userInfo)), needsSave: \(self.needsSave), keywords: \(String(describing: self.keywords)), persistentIdentifier: \(String(describing: self.persistentIdentifier)), isEligibleForHandoff: \(self.isEligibleForHandoff), isEligibleForSearch: \(self.isEligibleForSearch), isEligibleForPublicIndexing: \(self.isEligibleForPublicIndexing), expirationDate: \(String(describing: self.expirationDate)), webpageURL: \(String(describing: self.webpageURL)), isEligibleForPrediction: \(self.isEligibleForPrediction), suggestedInvocationPhrase: \(String(describing: self.suggestedInvocationPhrase))"
    }
}
