//
//  RCTBridge+UIScene.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 09/09/2022.
//

#import "RCTBridge+UIScene.h"

@implementation RCTBridge (UIScene)

- (instancetype)initWithDelegate:(id<RCTBridgeDelegate>)delegate
               connectionOptions:(UISceneConnectionOptions *)connectionOptions
{
    if (connectionOptions.userActivities.count < 1) {
        return [self initWithDelegate:delegate launchOptions:@{}];
    }

    NSUserActivity *userActivity = connectionOptions.userActivities.allObjects[0];

    if (!userActivity) {
        return [self initWithDelegate:delegate launchOptions:@{}];
    }

    NSDictionary<NSString *, id> *userActivityDict = @{
        UIApplicationLaunchOptionsUserActivityTypeKey: userActivity.activityType,
        @"UIApplicationLaunchOptionsUserActivityKey": userActivity,
    };
    NSDictionary<UIApplicationLaunchOptionsKey, id> *launchOptions = @{
        UIApplicationLaunchOptionsUserActivityDictionaryKey: userActivityDict,
    };

    return [self initWithDelegate:delegate launchOptions:launchOptions];
}

@end
