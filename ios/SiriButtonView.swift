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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    func setupButton(style: INUIAddVoiceShortcutButtonStyle = SiriButtonView.DEFAULT_STYLE) {
        // TODO: Initialize with passed in styling
        button = INUIAddVoiceShortcutButton(style: style)
        // Remove constraints so that the button renders with the default size Apple intended
        button.translatesAutoresizingMaskIntoConstraints = false
        // TODO: Wire up an onPress in JS
        button.addTarget(self, action: #selector(SiriButtonView.onClick), for: .touchUpInside)
    }
    
    @objc(setButtonStyle:)
    public func setButtonStyle(_ buttonStyle: NSNumber) {
        NSLog("Style: \(buttonStyle)")
        
        let style = INUIAddVoiceShortcutButtonStyle.init(rawValue: buttonStyle.uintValue) ?? SiriButtonView.DEFAULT_STYLE
        setupButton(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add the button as a subview
    public override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = self.bounds
        self.addSubview(button)
        
        // Center button in view
        self.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
    
    @objc func onClick() {
        NSLog("On Click")
    }
}
