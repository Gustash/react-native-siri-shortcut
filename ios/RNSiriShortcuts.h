//
//  RNSiriShortcuts.h
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 27/03/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#ifndef RNSiriShortcuts_h
#define RNSiriShortcuts_h

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNSiriShortcuts : RCTEventEmitter <RCTBridgeModule>

@property (class, nonatomic, strong) NSUserActivity * _Nullable initialUserActivity;

+ (void)shortcutReceived:(NSUserActivity *)activity;

@end

NS_ASSUME_NONNULL_END

#endif /* RNSiriShortcuts_h */
