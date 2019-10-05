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
open class RNTAddToSiriButtonManager : RCTViewManager {
    @objc override open func view() -> UIView! {
        return SiriButtonView(frame: UIScreen().bounds)
    }
    
    override static public func requiresMainQueueSetup() -> Bool {
        return true
    }
}
