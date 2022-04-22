//
//  RNSSSiriShortcuts.h
//  RNSSSiriShortcuts
//
//  Created by Gustavo Parreira on 27/03/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#ifndef RNSSSiriShortcuts_h
#define RNSSSiriShortcuts_h

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 12000) /* __IPHONE_12_0 */
#import <UIKit/UIUserActivity.h>
#endif

#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNSSSiriShortcuts : RCTEventEmitter

+ (BOOL)application:(nonnull UIApplication *)application
    continueUserActivity:(nonnull NSUserActivity *)userActivity
      restorationHandler:
        #if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 12000) /* __IPHONE_12_0 */
            (nonnull void (^)(NSArray<id<UIUserActivityRestoring>> *_Nullable))restorationHandler;
        #else
            (nonnull void (^)(NSArray *_Nullable))restorationHandler;
        #endif

@end

NS_ASSUME_NONNULL_END

#endif /* RNSSSiriShortcuts_h */
