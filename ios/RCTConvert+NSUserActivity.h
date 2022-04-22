//
//  RCTConvert+NSUserActivity.h
//  Pods
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#ifndef RCTConvert_NSUserActivity_h
#define RCTConvert_NSUserActivity_h

#import <React/RCTConvert.h>
#import <UIKit/UIKit.h>

@interface RCTConvert (NSUserActivity)

+ (NSUserActivity *)NSUserActivity:(id)json;

@end

#endif /* RCTConvert_NSUserActivity_h */
