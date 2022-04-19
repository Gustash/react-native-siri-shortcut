//
//  ShortcutOptions.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 19/04/2022.
//

#import "ShortcutOptions.h"
#import <React/RCTConvert.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ShortcutOptions

@synthesize activityType,
            title,
            requiredUserInfoKeys,
            userInfo,
            needsSave,
            keywords,
            expirationDate,
            webpageURL,
            suggestedInvocationPhrase,
            persistentIdentifier,
            contentType,
            contentDescription,
            isEligibleForHandoff,
            isEligibleForSearch,
            isEligibleForPrediction,
            isEligibleForPublicIndexing;

- (instancetype)initWithJSONOptions:(NSDictionary<NSString *, id> *)json
{
    self = [super init];
    if (self) {
        activityType = [RCTConvert NSString:json[@"activityType"]];
        title = [RCTConvert NSString:json[@"title"]];
        requiredUserInfoKeys = [RCTConvert NSSet:json[@"requiredUserInfoKeys"]];
        userInfo = [RCTConvert NSDictionary:json[@"userInfo"]];
        keywords = [RCTConvert NSStringArray:json[@"keywords"]];
        persistentIdentifier = [RCTConvert NSString:json[@"persistentIdentifier"]];
        expirationDate = [RCTConvert NSDate:json[@"expirationDate"]];
        webpageURL = [RCTConvert NSString:json[@"webpageURL"]];
        suggestedInvocationPhrase = [RCTConvert NSString:json[@"suggestedInvocationPhrase"]];
        needsSave = [RCTConvert BOOL:json[@"needsSave"]];
        isEligibleForHandoff = [RCTConvert BOOL:json[@"isEligibleForHandoff"]];
        isEligibleForSearch = [RCTConvert BOOL:json[@"isEligibleForSearch"]];
        isEligibleForPublicIndexing = [RCTConvert BOOL:json[@"isEligibleForPublicIndexing"]];
        isEligibleForPrediction = [RCTConvert BOOL:json[@"isEligibleForPrediction"]];
        contentDescription = [RCTConvert NSString:json[@"description"]];
        if (json[@"contentType"] != nil) {
            contentType = CFBridgingRetain([RCTConvert NSString:json[@"contentType"]]);
        } else {
            contentType = kUTTypeItem;
        }
    }
    return self;
}

@end
