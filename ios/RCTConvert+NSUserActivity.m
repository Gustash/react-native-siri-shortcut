//
//  RCTConvert+NSUserActivity.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#import "RCTConvert+NSUserActivity.h"
#import <Intents/Intents.h>
#import <CoreSpotlight/CoreSpotlight.h>

@implementation RCTConvert (NSUserActivity)

+ (NSUserActivity *)NSUserActivity:(id)json
{
    json = [self NSDictionary:json];
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:[self NSString:json[@"activityType"]]];
    userActivity.title = [self NSString:json[@"title"]];
    userActivity.requiredUserInfoKeys = [self NSSet:json[@"requiredUserInfoKeys"]];
    userActivity.userInfo = [self NSDictionary:json[@"userInfo"]];
    userActivity.needsSave = [self BOOL:json[@"needsSave"]];
    userActivity.keywords = [self NSSet:json[@"keywords"]];
    userActivity.expirationDate = [self NSDate:json[@"expirationDate"]];
    userActivity.webpageURL = [self NSURL:json[@"webpageURL"]];
    [userActivity setEligibleForHandoff:[self BOOL:json[@"isEligibleForHandoff"]]];
    [userActivity setEligibleForSearch:[self BOOL:json[@"isEligibleForSearch"]]];
    [userActivity setEligibleForPublicIndexing:[self BOOL:json[@"isEligibleForPublicIndexing"]]];
    
    if (@available(iOS 12.0, *)) {
        userActivity.suggestedInvocationPhrase = [self NSString:json[@"suggestedInvocationPhrase"]];
        userActivity.persistentIdentifier = [self NSString:json[@"persistentIdentifier"]];
        [userActivity setEligibleForPrediction:[self BOOL:json[@"isEligibleForPrediction"]]];
    }
    
    CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc]
                                                initWithItemContentType:[self NSString:json[@"contentType"]]];
    attributes.contentDescription = [self NSString:json[@"description"]];
    userActivity.contentAttributeSet = attributes;
    
    return userActivity;
}

@end
