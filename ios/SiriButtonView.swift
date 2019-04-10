//
//  SiriButtonView.swift
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 23/10/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import Intents
import IntentsUI
import UIKit

@available(iOS 12.0, *)
@objc(SiriButtonView)
public class SiriButtonView : UIView {
    var style: INUIAddVoiceShortcutButtonStyle = .white
    var button: INUIAddVoiceShortcutButton
    var onPress: RCTBubblingEventBlock?
    
    override init(frame: CGRect) {
        button = INUIAddVoiceShortcutButton(style: style)
        
        super.init(frame: frame)
        setupButton()
    }
    
    func setupButton(style: INUIAddVoiceShortcutButtonStyle? = nil, shortcut: INShortcut? = nil) {
        // Remove from container before re-declaring
        button.removeFromSuperview()
        
        // TODO: Initialize with passed in styling
        self.style = style ?? self.style
        button = INUIAddVoiceShortcutButton(style: self.style)
        // Remove constraints so that the button renders with the default size Apple intended
        button.translatesAutoresizingMaskIntoConstraints = false
        // Wire up with the JS onPress
        button.addTarget(self, action: #selector(SiriButtonView.onClick), for: .touchUpInside)
        // Add the shortcut, if provided
        button.shortcut = shortcut
        
        // Add new button to subview
        self.addSubview(button)
    }
    
    @objc(setButtonStyle:)
    public func setButtonStyle(_ buttonStyle: NSNumber) {
        let style = INUIAddVoiceShortcutButtonStyle.init(rawValue: buttonStyle.uintValue)
        setupButton(style: style, shortcut: button.shortcut)
    }
    
    @objc(setOnPress:)
    public func setOnPress(_ onPress: @escaping RCTBubblingEventBlock) {
        self.onPress = onPress
    }
    
    @objc(setShortcut:)
    public func setShortcut(_ jsonOptions: Dictionary<String, Any>) {
        let activity = ShortcutsModule.generateUserActivity(jsonOptions)
        let shortcut = INShortcut(userActivity: activity)
        setupButton(style: self.style, shortcut: shortcut)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add the button as a subview
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Center button in view
        self.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
    
    @objc func onClick() {
        onPress?(nil)
    }
}
