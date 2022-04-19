//
//  RNSiriShortcuts.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 23/09/2018.
//

#import "RNSiriShortcuts.h"
#import "ShortcutOptions.h"
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

static NSUserActivity * _Nullable _initialUserActivity = nil;

+ (NSUserActivity *)initialUserActivity
{
    return _initialUserActivity;
}

+ (void)setInitialUserActivity:(NSUserActivity *)initialUserActivity
{
    if (initialUserActivity != _initialUserActivity) {
        _initialUserActivity = initialUserActivity;
    }
}

+ (void)shortcutReceived:(NSUserActivity *)activity
{
    NSDictionary * _Nullable userInfo = activity.userInfo;
    NSString *activityType = activity.activityType;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"InitialUserActivity"
                                      object:nil
                                    userInfo:@{
        @"userInfo": userInfo ?: [NSNull null],
        @"activityType": activityType,
    }];
}

#pragma mark RCTBridgeModule

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

#pragma mark Contructors

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(startedFromShortcutWithNotification:)
                                   name:@"InitialUserActivity"
                                 object:nil];
    }
    return self;
}

#pragma mark Observers

- (void)startedFromShortcutWithNotification:(NSNotification *)notification
{
    if (notification.userInfo == nil) {
        return;
    }
    
    if (_hasListeners) {
        [self sendEventWithName:@"SiriShortcutListener"
                           body:notification.userInfo];
    }
}

#pragma mark RCTEventEmitter

- (void)startObserving
{
    _hasListeners = YES;
    
    NSUserActivity *initialUserActivity = RNSiriShortcuts.initialUserActivity;
    if (initialUserActivity != nil) {
        [RNSiriShortcuts shortcutReceived:initialUserActivity];
        RNSiriShortcuts.initialUserActivity = nil;
    }
}

- (void)stopObserving
{
    _hasListeners = NO;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"SiriShortcutListener"];
}

#pragma mark RCT_EXPORT_METHODS

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
    NSUserActivity *activity = [RNSiriShortcuts generateUserActivityFromJsonOptions:options];
    
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
            NSUserActivity *activity = [RNSiriShortcuts generateUserActivityFromJsonOptions:options];
            [suggestions addObject:[[INShortcut alloc] initWithUserActivity:activity]];
        }
        
        [[INVoiceShortcutCenter sharedCenter] setShortcutSuggestions:suggestions];
    }
}

RCT_EXPORT_METHOD(presentShortcut:(NSDictionary *)options
                  callback:(RCTResponseSenderBlock)callback)
{
    if (@available(iOS 12.0, *)) {
        NSUserActivity *activity = [RNSiriShortcuts generateUserActivityFromJsonOptions:options];
    
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
                        @"title": userActivity.title ?: [NSNull null],
                        @"requiredUserInfoKeys": userActivity.requiredUserInfoKeys ?: [NSNull null],
                        @"userInfo": userActivity.userInfo ?: [NSNull null],
                        @"needsSave": @(userActivity.needsSave),
                        @"keywords": userActivity.keywords ?: [NSNull null],
                        @"persistentIndentifier": userActivity.persistentIdentifier ?: [NSNull null],
                        @"isEligibleForHandoff": @(userActivity.isEligibleForHandoff),
                        @"isEligibleForSearch": @(userActivity.isEligibleForSearch),
                        @"isEligibleForPublicIndexing": @(userActivity.isEligibleForPublicIndexing),
                        @"expirationDate": userActivity.expirationDate ?: [NSNull null],
                        @"webpageURL": userActivity.webpageURL ?: [NSNull null],
                        @"isEligibleForPrediction": @(userActivity.isEligibleForPrediction),
                        @"suggestedInvocationPhrase": userActivity.suggestedInvocationPhrase ?: [NSNull null],
                    };
                }
                
                [result addObject:@{
                    @"identifier": voiceShortcut.identifier.UUIDString,
                    @"phrase": voiceShortcut.invocationPhrase,
                    @"options": options ?: [NSNull null],
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
                    @"phrase": invocationPhrase ?: [NSNull null],
                }
            ]);
            self->_presentShortcutCallback = nil;
        }
    });
}

#pragma mark Converters

+ (NSUserActivity *)generateUserActivityFromJsonOptions:(NSDictionary<NSString *, id> *)jsonOptions
{
    ShortcutOptions *options = [[ShortcutOptions alloc] initWithJSONOptions:jsonOptions];
    
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:options.activityType];
    activity.title = options.title;
    activity.requiredUserInfoKeys = options.requiredUserInfoKeys;
    activity.userInfo = options.userInfo;
    activity.needsSave = options.needsSave;
    activity.keywords = [[NSSet alloc] initWithArray:options.keywords ? options.keywords : @[]];
    [activity setEligibleForHandoff:options.isEligibleForHandoff];
    [activity setEligibleForSearch:options.isEligibleForSearch];
    [activity setEligibleForPublicIndexing:options.isEligibleForPublicIndexing];
    activity.expirationDate = options.expirationDate;
    
    if (options.webpageURL) {
        activity.webpageURL = [[NSURL alloc] initWithString:options.webpageURL];
    }
    
    if (@available(iOS 12.0, *)) {
        [activity setEligibleForPrediction:options.isEligibleForPrediction];
        activity.suggestedInvocationPhrase = options.suggestedInvocationPhrase;
        activity.persistentIdentifier = options.persistentIdentifier;
    }
    
    CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)options.contentType];
    if (options.contentDescription) {
        attributes.contentDescription = options.contentDescription;
    }
    activity.contentAttributeSet = attributes;
    
    return activity;
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
    if (deletedShortcut == nil) {
        [self dismissPresenterWithStatus:MutationStatusDeleted
                           voiceShortcut:nil];
        return;
    }
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
