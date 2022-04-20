//
//  NSUserActivity+ShortcutOptions.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 19/04/2022.
//

#import "NSUserActivity+ShortcutOptions.h"
#import <React/RCTConvert.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Intents/Intents.h>
#import <CoreSpotlight/CoreSpotlight.h>

@implementation NSUserActivity (ShortcutOptions)

- (instancetype)initWithJSONOptions:(NSDictionary<NSString *,id> *)jsonOptions
{
    if (self = [self initWithActivityType:[RCTConvert NSString:jsonOptions[@"activityType"]]]) {
        self.title = [RCTConvert NSString:jsonOptions[@"title"]];
        self.requiredUserInfoKeys = [RCTConvert NSSet:jsonOptions[@"requiredUserInfoKeys"]];
        self.userInfo = [RCTConvert NSDictionary:jsonOptions[@"userInfo"]];
        self.needsSave = [RCTConvert BOOL:jsonOptions[@"needsSave"]];
        self.keywords = [RCTConvert NSSet:jsonOptions[@"keywords"]];
        self.expirationDate = [RCTConvert NSDate:jsonOptions[@"expirationDate"]];
        self.webpageURL = [RCTConvert NSURL:jsonOptions[@"webpageURL"]];
        [self setEligibleForHandoff:[RCTConvert BOOL:jsonOptions[@"isEligibleForHandoff"]]];
        [self setEligibleForSearch:[RCTConvert BOOL:jsonOptions[@"isEligibleForSearch"]]];
        [self setEligibleForPublicIndexing:[RCTConvert BOOL:jsonOptions[@"isEligibleForPublicIndexing"]]];
        
        if (@available(iOS 12.0, *)) {
            self.suggestedInvocationPhrase = [RCTConvert NSString:jsonOptions[@"suggestedInvocationPhrase"]];
            self.persistentIdentifier = [RCTConvert NSString:jsonOptions[@"persistentIdentifier"]];
            [self setEligibleForPrediction:[RCTConvert BOOL:jsonOptions[@"isEligibleForPrediction"]]];
        }
        
        CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc]
                                                    initWithItemContentType:[RCTConvert NSString:jsonOptions[@"contentType"]]];
        NSString * _Nullable contentDescription = [RCTConvert NSString:jsonOptions[@"description"]];
        if (contentDescription) {
            attributes.contentDescription = contentDescription;
        }
        self.contentAttributeSet = attributes;
    }
    
    return self;
}

@end
