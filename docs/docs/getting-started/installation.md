---
sidebar_position: 0
slug: /
---

# Installation

To get this package installed, run the following commands in your Terminal.

```bash npm2yarn
npm install react-native-siri-shortcut

pod install --project-directory=ios
```

Then, in your `AppDelegate.mm` add the following lines of code.

```objectivec title="AppDelegate.mm"
//...

// highlight-next-line
#import <RNSiriShortcuts/RNSiriShortcuts.h>

@implementation AppDelegate

//...

// highlight-start
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
  return [RNSSSiriShortcuts application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}
// highlight-end

@end
```

:::caution Important
Make sure that the import is added outside the `#if RCT_NEW_ARCH_ENABLED`, otherwise the compiler will only import the header
if your project has the New Architecture enabled!
:::
