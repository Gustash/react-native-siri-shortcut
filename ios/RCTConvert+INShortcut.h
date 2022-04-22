//
//  RCTConvert+INShortcut.h
//  Pods
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#ifndef RCTConvert_INShortcut_h
#define RCTConvert_INShortcut_h

#import <React/RCTConvert.h>
#import <Intents/Intents.h>

API_AVAILABLE(ios(12.0))
@interface RCTConvert (INShortcut)

+ (INShortcut *)INShortcut:(id)json;

@end

#endif /* RCTConvert_INShortcut_h */
