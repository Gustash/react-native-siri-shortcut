//
//  RNSSAddToSiriButtonViewManager.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#import <React/RCTViewManager.h>
#import "RNSSAddToSiriButton.h"
#import "RCTConvert+INShortcut.h"
#import "RCTConvert+INUIAddVoiceShortcutButtonStyle.h"

API_AVAILABLE(ios(12.0))
@interface RNSSAddToSiriButtonViewManager : RCTViewManager
@end

@implementation RNSSAddToSiriButtonViewManager

RCT_EXPORT_MODULE(RNSSAddToSiriButton)

- (UIView *)view
{
    return [RNSSAddToSiriButton new];
}

RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(shortcut, INShortcut, RNSSAddToSiriButton)
{
    [view.button setShortcut:json ? [RCTConvert INShortcut:json] : defaultView.button.shortcut];
}

RCT_CUSTOM_VIEW_PROPERTY(buttonStyle, INUIAddVoiceShortcutButtonStyle, RNSSAddToSiriButton)
{
    [view setStyle:json ? [RCTConvert INUIAddVoiceShortcutButtonStyle:json] : defaultView.button.style];
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (NSDictionary *)constantsToExport
{
    INUIAddVoiceShortcutButton *button = [INUIAddVoiceShortcutButton alloc];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button layoutIfNeeded];
    
    NSMutableDictionary *availableStyles = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"white": @(INUIAddVoiceShortcutButtonStyleWhite),
        @"whiteOutline": @(INUIAddVoiceShortcutButtonStyleWhiteOutline),
        @"black": @(INUIAddVoiceShortcutButtonStyleBlack),
        @"blackOutline": @(INUIAddVoiceShortcutButtonStyleBlackOutline),
    }];
    if (@available(iOS 13.0, *)) {
        availableStyles[@"automatic"] = @(INUIAddVoiceShortcutButtonStyleAutomatic);
        availableStyles[@"automaticOutline"] = @(INUIAddVoiceShortcutButtonStyleAutomaticOutline);
    }
    
    return @{
        @"ComponentWidth": @(button.intrinsicContentSize.width),
        @"ComponentHeight": @(button.intrinsicContentSize.height),
        @"AvailableStyles": availableStyles,
    };
}

@end
