/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
  
  // Check if the app launched with any shortcuts
  BOOL launchedFromShortcut = [launchOptions objectForKey:@"UIApplicationLaunchOptionsUserActivityDictionaryKey"] != nil;
  // Add a boolean to the initialProperties to let the app know you got the initial shortcut
  NSDictionary *initialProperties = @{ @"launchedFromShortcut":@(launchedFromShortcut) };

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"example"
                                               initialProperties:initialProperties // Add the initial properties here
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

// This method checks for shortcuts issued to the app
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler
{
  NSDictionary *userInfo = userActivity.userInfo;
  
  RCTRootView *rootView = (RCTRootView*) [self.window rootViewController].view;
  // If the initial properties say the app launched from a shortcut (see above), send the shortcut data to the appProperties, re-rendering the app.
  // This only happens once and only if the app was laucnhed from a shortcut, so you won't have any unnecessary re-renders.
  if ([[rootView.appProperties objectForKey:@"launchedFromShortcut"] boolValue]) {
    rootView.appProperties = @{ @"initialShortcutUserInfo":userInfo, @"launchedFromShortcut":@NO };
  }
  
  // Post notification data to the Notification Center so the module can send it to a JS listener.
  [[NSNotificationCenter defaultCenter] postNotificationName:@"InitialUserActivity" object:nil userInfo:userInfo];
  
  return YES;
}

@end
