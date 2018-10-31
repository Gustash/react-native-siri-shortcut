//
//  RNTAddToSiriButtonManager.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 24/10/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "React/RCTViewManager.h"
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(RNTAddToSiriButtonManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(buttonStyle, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(shortcut, NSDictionary)

@end
