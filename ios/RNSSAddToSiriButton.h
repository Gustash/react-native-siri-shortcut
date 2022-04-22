//
//  RNSSAddToSiriButton.h
//  Pods
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#ifndef RNSSAddToSiriButton_h
#define RNSSAddToSiriButton_h

#import <React/RCTComponent.h>
#import <IntentsUI/IntentsUI.h>

API_AVAILABLE(ios(12.0))
@interface RNSSAddToSiriButton : UIView

@property (nonatomic, copy) RCTBubblingEventBlock onPress;

- (INUIAddVoiceShortcutButton *)button;

- (void)setStyle:(INUIAddVoiceShortcutButtonStyle)style;

@end

#endif /* RNSSAddToSiriButton_h */
