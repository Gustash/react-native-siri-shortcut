//
//  NSUserActivity+ShortcutOptions.h
//  RNSiriShortcuts
//
//  Created by Gustavo Parreira on 19/04/2022.
//

#ifndef NSUserActivity__ShortcutOptions_h
#define NSUserActivity__ShortcutOptions_h

NS_ASSUME_NONNULL_BEGIN

@interface NSUserActivity (ShortcutOptions)

- (instancetype)initWithJSONOptions:(NSDictionary<NSString *, id> *)jsonOptions;

@end

NS_ASSUME_NONNULL_END

#endif /* NSUserActivity__ShortcutOptions_h */
