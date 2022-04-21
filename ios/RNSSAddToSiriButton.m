//
//  RNSSAddToSiriButton.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#import "RNSSAddToSiriButton.h"

@implementation RNSSAddToSiriButton

- (instancetype)init
{
    if (self = [super init]) {
        INUIAddVoiceShortcutButtonStyle defaultStyle = INUIAddVoiceShortcutButtonStyleWhite;
        if (@available(iOS 13.0, *)) {
            defaultStyle = INUIAddVoiceShortcutButtonStyleAutomatic;
        }
        [self setupButtonWithShortcut:nil style:defaultStyle];
    }
    return self;
}

- (void)setupButtonWithShortcut:(INShortcut * _Nullable)shortcut
                          style:(INUIAddVoiceShortcutButtonStyle)style
{
    INUIAddVoiceShortcutButton *button = [[INUIAddVoiceShortcutButton alloc]
                                          initWithStyle:style];
    button.shortcut = shortcut;
    
    // Make sure to remove all subviews so the new button is the only subview
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self addSubview:button];
    [[button.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[button.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[button.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
    [[button.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
    
    [button addTarget:self
               action:@selector(handleButtonPress)
     forControlEvents:UIControlEventTouchUpInside];
}

- (INUIAddVoiceShortcutButton *)button
{
    return self.subviews[0];
}

- (void)setStyle:(INUIAddVoiceShortcutButtonStyle)style
{
    if (@available(iOS 13.0, *)) {
        self.button.style = style;
    } else {
        [self setupButtonWithShortcut:self.button.shortcut style:style];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button.frame = self.bounds;
}

- (void)handleButtonPress
{
    if (!self.onPress) {
        return;
    }
    
    self.onPress(nil);
}

@end
