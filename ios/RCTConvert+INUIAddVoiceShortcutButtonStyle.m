//
//  RCTConvert+INUIAddVoiceShortcutButtonStyle.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#import "RCTConvert+INUIAddVoiceShortcutButtonStyle.h"

API_AVAILABLE(ios(12.0))
@implementation RCTConvert (INUIAddVoiceShortcutButtonStyle)

+ (INUIAddVoiceShortcutButtonStyle)INUIAddVoiceShortcutButtonStyle:(id)json
{
    switch ([self NSUInteger:json]) {
        case INUIAddVoiceShortcutButtonStyleWhite:
            return INUIAddVoiceShortcutButtonStyleWhite;
        case INUIAddVoiceShortcutButtonStyleWhiteOutline:
            return INUIAddVoiceShortcutButtonStyleWhiteOutline;
        case INUIAddVoiceShortcutButtonStyleBlack:
            return INUIAddVoiceShortcutButtonStyleBlack;
        case INUIAddVoiceShortcutButtonStyleBlackOutline:
            return INUIAddVoiceShortcutButtonStyleBlackOutline;
        case 4: // INUIAddVoiceShortcutButtonStyleAutomatic
            if (@available(iOS 13.0, *)) {
                return INUIAddVoiceShortcutButtonStyleAutomatic;
            }
            return INUIAddVoiceShortcutButtonStyleWhite;
        case 5: // INUIAddVoiceShortcutButtonStyleAutomaticOutline
            if (@available(iOS 13.0, *)) {
                return INUIAddVoiceShortcutButtonStyleAutomaticOutline;
            }
            return INUIAddVoiceShortcutButtonStyleWhiteOutline;
        default:
            return INUIAddVoiceShortcutButtonStyleWhite;
    }
}

@end
