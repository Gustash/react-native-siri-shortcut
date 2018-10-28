//
//  SiriButtonView.swift
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 23/10/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation
import IntentsUI
import UIKit

@available(iOS 12.0, *)
@objc(SiriButtonView)
public class SiriButtonView : UIView {
    static let DEFAULT_STYLE = INUIAddVoiceShortcutButtonStyle.white
    var button: INUIAddVoiceShortcutButton = INUIAddVoiceShortcutButton(style: DEFAULT_STYLE)
    var onPress: RCTBubblingEventBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    func setupButton(style: INUIAddVoiceShortcutButtonStyle = SiriButtonView.DEFAULT_STYLE) {
        // Remove from container before re-declaring
        button.removeFromSuperview()
        
        // TODO: Initialize with passed in styling
        button = INUIAddVoiceShortcutButton(style: style)
        // Remove constraints so that the button renders with the default size Apple intended
        button.translatesAutoresizingMaskIntoConstraints = false
        // TODO: Wire up an onPress in JS
        button.addTarget(self, action: #selector(SiriButtonView.onClick), for: .touchUpInside)
        
        // Add new button to subview
        self.addSubview(button)
    }
    
    @objc(setButtonStyle:)
    public func setButtonStyle(_ buttonStyle: NSNumber) {
        let style = INUIAddVoiceShortcutButtonStyle.init(rawValue: buttonStyle.uintValue) ?? SiriButtonView.DEFAULT_STYLE
        
        setupButton(style: style)
    }
    
    @objc(setOnPress:)
    public func setOnPress(_ onPress: @escaping RCTBubblingEventBlock) {
        self.onPress = onPress
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
