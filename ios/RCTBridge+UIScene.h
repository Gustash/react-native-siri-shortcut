//
//  RCTBridge+UIScene.h
//  Pods
//
//  Created by Gustavo Parreira on 09/09/2022.
//

#ifndef RCTBridge_UIScene_h
#define RCTBridge_UIScene_h

#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTBridge (UIScene)

- (instancetype)initWithDelegate:(id<RCTBridgeDelegate>)delegate
                       connectionOptions:(UISceneConnectionOptions *)connectionOptions
API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END

#endif /* RCTBridge_UIScene_h */
