//
//  RNTAddToSiriButton.swift
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 23/10/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation

@available(iOS 12.0, *)
@objc (RNTAddToSiriButtonManager)
class RNTAddToSiriButtonManager : RCTViewManager {
    @objc override func view() -> UIView! {
        return SiriButtonView(frame: UIScreen().bounds)
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
