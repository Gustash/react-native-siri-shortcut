//
//  RNSiriShortcuts.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 23/09/2018.
//

#import "RNSiriShortcuts.h"
#import "NSUserActivity+ShortcutOptions.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>
#import <React/RCTEventEmitter.h>
#import <UIKit/UIKit.h>
#import <Intents/Intents.h>
#import <IntentsUI/IntentsUI.h>
#import <CoreSpotlight/CoreSpotlight.h>

enum MutationStatus {
    MutationStatusCancelled,
    MutationStatusAdded,
    MutationStatusUpdated,
    MutationStatusDeleted,
};

NSString *MutationStatusToString(enum MutationStatus status) {
    switch (status) {
        case MutationStatusCancelled:
            return @"cancelled";
        case MutationStatusAdded:
            return @"added";
        case MutationStatusUpdated:
            return @"updated";
        case MutationStatusDeleted:
            return @"deleted";
    }
}

@interface RNSiriShortcuts () <INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate>
@end

@implementation RNSiriShortcuts {
    RCTResponseSenderBlock _Nullable _presentShortcutCallback;
    NSObject * _Nullable _editingVoiceShortcut; // Keep support for iOS <9
    UIViewController * _Nullable _presenterViewController;
    BOOL _hasListeners;
}
@synthesize bridge;

RCT_EXPORT_MODULE();

- (INVoiceShortcut * _Nullable)editingVoiceShortcut
API_AVAILABLE(ios(12.0))
{
    if ([_editingVoiceShortcut isKindOfClass:[INVoiceShortcut class]]) {
        return (INVoiceShortcut *)_editingVoiceShortcut;
    }
    return nil;
}

- (void)setEditingVoiceShortcut:(INVoiceShortcut * _Nullable)shortcut
API_AVAILABLE(ios(12.0))
{
    if (shortcut != _editingVoiceShortcut) {
        _editingVoiceShortcut = shortcut;
    }
}

#pragma mark Class Properties

+ (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 12000) /* __IPHONE_12_0 */
(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> *_Nullable))restorationHandler {
#else
(nonnull void (^)(NSArray *_Nullable))restorationHandler {
#endif
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"shortcutReceived"
                                      object:nil
                                    userInfo:@{
        @"userInfo": RCTNullIfNil(userActivity.userInfo),
        @"activityType": userActivity.activityType,
    }];
    return YES;
}

#pragma mark RCTBridgeModule

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

#pragma mark Contructors

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(handleReceivedShortcutNotification:)
                                   name:@"shortcutReceived"
                                 object:nil];
    }
    return self;
}

#pragma mark Observers

- (void)handleReceivedShortcutNotification:(NSNotification *)notification
{
    NSDictionary *activityInfo = notification.userInfo;
    
    if (_hasListeners) {
        [self sendEventWithName:@"SiriShortcutListener"
                           body:activityInfo];
    }
}

#pragma mark RCTEventEmitter

- (void)startObserving
{
    _hasListeners = YES;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleReceivedShortcutNotification:)
                               name:@"shortcutReceived"
                             object:nil];
}

- (void)stopObserving
{
    _hasListeners = NO;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self
                                  name:@"shortcutReceived"
                                object:nil];
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"SiriShortcutListener"];
}

#pragma mark RCT_EXPORT_METHODS

RCT_EXPORT_METHOD(getInitialShortcut:(RCTPromiseResolveBlock)resolve
                  rejecter:(__unused RCTPromiseRejectBlock)reject)
{
    // Extract the NSUserActivity data from launchOptions
    NSDictionary *userActivityDictionary = bridge.launchOptions[UIApplicationLaunchOptionsUserActivityDictionaryKey];
    NSDictionary * _Nullable shortcutInfo = nil;
    
    // If there was no NSUserActivity in launchOptions, the app was not launched from a shortcut
    if (userActivityDictionary) {
        NSArray<NSString *> *activityTypes = [NSBundle mainBundle].infoDictionary[@"NSUserActivityTypes"];
        // Check if the NSUserActivity.activityType matches one of the NSUserActivityTypes defined in Info.plist
        // If not, it was not launched from a shortcut that we should handle
        if ([activityTypes containsObject:userActivityDictionary[UIApplicationLaunchOptionsUserActivityTypeKey]]) {
            NSUserActivity *userActivity = userActivityDictionary[@"UIApplicationLaunchOptionsUserActivityKey"];
            shortcutInfo = @{
                @"userInfo": RCTNullIfNil(userActivity.userInfo),
                @"activityType": userActivity.activityType,
            };
        }
    }
    
    resolve(RCTNullIfNil(shortcutInfo));
}

RCT_EXPORT_METHOD(clearAllShortcuts:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 12.0, *)) {
        [NSUserActivity deleteAllSavedUserActivitiesWithCompletionHandler:^{
            resolve(nil);
        }];
    } else {
        reject(@"below_ios_12",
               @"Your device needs to be running iOS 12+ for this",
               nil);
    }
}

RCT_EXPORT_METHOD(clearShortcutsWithIdentifiers:(NSArray *)persistentIdentifiers
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 12.0, *)) {
        [NSUserActivity deleteSavedUserActivitiesWithPersistentIdentifiers:persistentIdentifiers
                                                         completionHandler:^{
            resolve(nil);
        }];
    } else {
        reject(@"below_ios_12",
               @"Your device needs to be running iOS 12+ for this",
               nil);
    };
}

RCT_EXPORT_METHOD(donateShortcut:(NSDictionary *)options)
{
    NSUserActivity *activity = [[NSUserActivity alloc] initWithJSONOptions:options];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication]
            .keyWindow
            .rootViewController
            .userActivity = activity;
    });
    [activity becomeCurrent];
}

RCT_EXPORT_METHOD(suggestShortcuts:(NSArray<NSDictionary *> *)shortcutOptionsArr)
{
    if (@available(iOS 12.0, *)) {
        NSMutableArray<INShortcut *> *suggestions = [NSMutableArray new];
        
        for (NSDictionary *options in shortcutOptionsArr) {
            NSUserActivity *activity = [[NSUserActivity alloc] initWithJSONOptions:options];
            [suggestions addObject:[[INShortcut alloc] initWithUserActivity:activity]];
        }
        
        [[INVoiceShortcutCenter sharedCenter] setShortcutSuggestions:suggestions];
    }
}

RCT_EXPORT_METHOD(presentShortcut:(NSDictionary *)options
                  callback:(RCTResponseSenderBlock)callback)
{
    if (@available(iOS 12.0, *)) {
        NSUserActivity *activity = [[NSUserActivity alloc] initWithJSONOptions:options];
    
        INShortcut *shortcut = [[INShortcut alloc] initWithUserActivity:activity];
        
        [self fetchRecordedVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> * _Nullable voiceShortcuts,
                                                          NSError * _Nullable error) {
            if (voiceShortcuts == nil) {
                if (error != nil) {
                    NSString *errorMsg = [[NSString alloc] initWithFormat:@"failed to fetch recorded shortcuts: %@", error];
                    callback(@[
                        @{
                            @"status": MutationStatusToString(MutationStatusCancelled),
                            @"error": errorMsg,
                        }
                    ]);
                    return;
                }
                
                callback(@[
                    @{
                        @"status": MutationStatusToString(MutationStatusCancelled),
                        @"error": @"unknown error fetching recorded shortcuts",
                    }
                ]);
                return;
            }
            
            self->_presentShortcutCallback = callback;
            INVoiceShortcut *addedVoiceShortcut;
            for (INVoiceShortcut *voiceShortcut in voiceShortcuts) {
                NSUserActivity * _Nullable userActivity = voiceShortcut.shortcut.userActivity;
                if (userActivity != nil &&
                    [userActivity.activityType isEqualToString:activity.activityType]) {
                    addedVoiceShortcut = voiceShortcut;
                    break;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (addedVoiceShortcut != nil) {
                    // The shortcut was already added, so we present a form to edit it
                    [self setEditingVoiceShortcut:addedVoiceShortcut];
                    INUIEditVoiceShortcutViewController *presenterViewController = [[INUIEditVoiceShortcutViewController alloc] initWithVoiceShortcut:addedVoiceShortcut];
                    [presenterViewController setDelegate:self];
                    self->_presenterViewController = presenterViewController;
                } else {
                    // The shortcut was not added yet, so present a form to add it
                    INUIAddVoiceShortcutViewController *presenterViewController = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortcut];
                    [presenterViewController setDelegate:self];
                    self->_presenterViewController = presenterViewController;
                }
                self->_presenterViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                [rootViewController presentViewController:self->_presenterViewController
                                                 animated:true
                                               completion:nil];
            });
        }];
    }
}

RCT_EXPORT_METHOD(getShortcuts:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 12.0, *)) {
        [self fetchRecordedVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> * _Nullable voiceShortcuts,
                                                          NSError * _Nullable error) {
            if (error != nil) {
                reject(@"get_shortcuts_failure",
                       error.localizedDescription,
                       error);
                return;
            }
            
            if (voiceShortcuts == nil) {
                reject(@"get_shortcuts_failure",
                       @"An unknown error has occurred. Please open an issue on GitHub.",
                       nil);
                return;
            }
            
            NSMutableArray<NSDictionary<NSString *, id> *> *result = [NSMutableArray new];
            for (INVoiceShortcut *voiceShortcut in voiceShortcuts) {
                NSDictionary<NSString *, id> * _Nullable options = nil;
                
                NSUserActivity * _Nullable userActivity = voiceShortcut.shortcut.userActivity;
                if (userActivity != nil) {
                    options = @{
                        @"activityType": userActivity.activityType,
                        @"title": RCTNullIfNil(userActivity.title),
                        @"requiredUserInfoKeys": RCTNullIfNil(userActivity.requiredUserInfoKeys),
                        @"userInfo": RCTNullIfNil(userActivity.userInfo),
                        @"needsSave": @(userActivity.needsSave),
                        @"keywords": RCTNullIfNil(userActivity.keywords),
                        @"persistentIndentifier": RCTNullIfNil(userActivity.persistentIdentifier),
                        @"isEligibleForHandoff": @(userActivity.isEligibleForHandoff),
                        @"isEligibleForSearch": @(userActivity.isEligibleForSearch),
                        @"isEligibleForPublicIndexing": @(userActivity.isEligibleForPublicIndexing),
                        @"expirationDate": RCTNullIfNil(userActivity.expirationDate),
                        @"webpageURL": RCTNullIfNil(userActivity.webpageURL),
                        @"isEligibleForPrediction": @(userActivity.isEligibleForPrediction),
                        @"suggestedInvocationPhrase": RCTNullIfNil(userActivity.suggestedInvocationPhrase),
                    };
                }
                
                [result addObject:@{
                    @"identifier": voiceShortcut.identifier.UUIDString,
                    @"phrase": voiceShortcut.invocationPhrase,
                    @"options": RCTNullIfNil(options),
                }];
            }
            resolve(result);
        }];
    }
}

#pragma mark Helpers

API_AVAILABLE(ios(12.0))
typedef void (^FetchRecordedVoiceShortcutsCompletionBlock)(NSArray<INVoiceShortcut *>  * _Nullable voiceShortcuts, NSError  * _Nullable error);
- (void)fetchRecordedVoiceShortcutsWithCompletion:(FetchRecordedVoiceShortcutsCompletionBlock)completion
API_AVAILABLE(ios(12.0))
{
    [[INVoiceShortcutCenter sharedCenter] getAllVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> * _Nullable voiceShortcuts,
                                                                               NSError * _Nullable error) {
        if (error != nil) {
            completion(nil, error);
            return;
        }
        
        if (voiceShortcuts != nil) {
            completion(voiceShortcuts, nil);
            return;
        }
        
        completion(nil, nil);
    }];
}

- (void)dismissPresenterWithStatus:(enum MutationStatus)status
                     voiceShortcut:(nullable INVoiceShortcut *)shortcut
API_AVAILABLE(ios(12.0))
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_presenterViewController != nil) {
            [self->_presenterViewController dismissViewControllerAnimated:YES completion:nil];
            self->_presenterViewController = nil;
        }
        
        if (self->_presentShortcutCallback != nil) {
            NSString *invocationPhrase = nil;
            if (shortcut != nil) {
                invocationPhrase = shortcut.invocationPhrase;
            }
            self->_presentShortcutCallback(@[
                @{
                    @"status": MutationStatusToString(status),
                    @"phrase": RCTNullIfNil(invocationPhrase),
                }
            ]);
            self->_presentShortcutCallback = nil;
        }
    });
}

#pragma mark INUIAddVoiceShortcutViewControllerDelegate

- (void)addVoiceShortcutViewController:(nonnull INUIAddVoiceShortcutViewController *)controller
            didFinishWithVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut
                                 error:(nullable NSError *)error
API_AVAILABLE(ios(12.0))
{
    // Shortcut was added
    [self dismissPresenterWithStatus:MutationStatusAdded
                       voiceShortcut:voiceShortcut];
}

- (void)addVoiceShortcutViewControllerDidCancel:(nonnull INUIAddVoiceShortcutViewController *)controller
API_AVAILABLE(ios(12.0))
{
    // Adding shortcut cancelled
    [self dismissPresenterWithStatus:MutationStatusCancelled
                       voiceShortcut:nil];
}

#pragma mark INUIEditVoiceShortcutViewControllerDelegate

- (void)editVoiceShortcutViewController:(nonnull INUIEditVoiceShortcutViewController *)controller
   didDeleteVoiceShortcutWithIdentifier:(nonnull NSUUID *)deletedVoiceShortcutIdentifier
API_AVAILABLE(ios(12.0))
{
    // Shortcut was deleted
    INVoiceShortcut * _Nullable deletedShortcut = [self editingVoiceShortcut];
    [self dismissPresenterWithStatus:MutationStatusDeleted
                       voiceShortcut:deletedShortcut];
    [self setEditingVoiceShortcut:nil];
}

- (void)editVoiceShortcutViewController:(nonnull INUIEditVoiceShortcutViewController *)controller
                 didUpdateVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut
                                  error:(nullable NSError *)error
API_AVAILABLE(ios(12.0))
{
    // Shortcut was updated
    [self dismissPresenterWithStatus:MutationStatusUpdated voiceShortcut:voiceShortcut];
    [self setEditingVoiceShortcut:nil];
}

- (void)editVoiceShortcutViewControllerDidCancel:(nonnull INUIEditVoiceShortcutViewController *)controller
API_AVAILABLE(ios(12.0))
{
    // Shortcut edit was cancelled
    [self dismissPresenterWithStatus:MutationStatusCancelled
                       voiceShortcut:nil];
    [self setEditingVoiceShortcut:nil];
}

@end
