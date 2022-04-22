//
//  RCTConvert+INUIAddVoiceShortcutButtonStyle.h
//  Pods
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#ifndef RCTConvert_INUIAddVoiceShortcutButtonStyle_h
#define RCTConvert_INUIAddVoiceShortcutButtonStyle_h

#import <React/RCTConvert.h>
#import <IntentsUI/IntentsUI.h>

API_AVAILABLE(ios(12.0))
@interface RCTConvert (INUIAddVoiceShortcutButtonStyle)

+ (INUIAddVoiceShortcutButtonStyle)INUIAddVoiceShortcutButtonStyle:(id)json;

@end

#endif /* RCTConvert_INUIAddVoiceShortcutButtonStyle_h */
