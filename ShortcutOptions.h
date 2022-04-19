//
//  ShortcutOptions.h
//  Pods
//
//  Created by Gustavo Parreira on 19/04/2022.
//

#ifndef ShortcutOptions_h
#define ShortcutOptions_h

NS_ASSUME_NONNULL_BEGIN

@interface ShortcutOptions : NSObject

#pragma mark Properties
@property (readonly, nonatomic, strong) NSString *activityType;
@property (readonly, nonatomic, strong) NSString * _Nullable title;
@property (readonly, nonatomic, strong) NSSet<NSString *> * _Nullable requiredUserInfoKeys;
@property (readonly, nonatomic, strong) NSDictionary * _Nullable userInfo;
@property (readonly, nonatomic, assign) BOOL needsSave;
@property (readonly, nonatomic, strong) NSArray<NSString *> * _Nullable keywords;
@property (readonly, nonatomic, strong) NSDate * _Nullable expirationDate;
@property (readonly, nonatomic, strong) NSString * _Nullable webpageURL;
@property (readonly, nonatomic, strong) NSString * _Nullable suggestedInvocationPhrase;
@property (readonly, nonatomic, strong) NSString * _Nullable persistentIdentifier;
@property (readonly, nonatomic, assign) CFStringRef _Nullable contentType;
@property (readonly, nonatomic, strong) NSString * _Nullable contentDescription;
@property (readonly, nonatomic, assign) BOOL isEligibleForHandoff;
@property (readonly, nonatomic, assign) BOOL isEligibleForSearch;
@property (readonly, nonatomic, assign) BOOL isEligibleForPublicIndexing;
@property (readonly, nonatomic, assign) BOOL isEligibleForPrediction;

#pragma mark Constructors
- (instancetype)initWithJSONOptions:(NSDictionary<NSString *, id> *)jsonOptions;

@end

NS_ASSUME_NONNULL_END

#endif /* ShortcutOptions_h */
