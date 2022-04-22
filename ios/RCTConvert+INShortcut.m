//
//  RCTConvert+INShortcut.m
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 21/04/2022.
//

#import "RCTConvert+INShortcut.h"
#import "RCTConvert+NSUserActivity.h"

API_AVAILABLE(ios(12.0))
@implementation RCTConvert (INShortcut)

+ (INShortcut *)INShortcut:(id)json
{
    return [[INShortcut alloc] initWithUserActivity:[self NSUserActivity:json]];
}

@end
