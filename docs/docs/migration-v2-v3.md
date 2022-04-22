# Upgrading from 2.x

React Native Siri Shortcut introduced some breaking changes with React Native Siri Shortcut 3.

The `AppDelegate` setup has been simplified, `AddToSiriButton` is easier to use and there have been some other changes.

## AppDelegate

Previously, the `AppDelegate.m` setup was cumbersome and involved. With v3 it's almost a one-liner, so you just need to apply the following changes to your `AppDelegate.m`/`AppDelegate.mm`:

```diff title="AppDelegate.m"
// ... imports
- @import RNSiriShortcuts;
+ #import <RNSiriShortcuts/RNSiriShortcuts.h>

 - (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...

-  // Check if the app launched with any shortcuts
-  BOOL launchedFromShortcut = [launchOptions objectForKey:@"UIApplicationLaunchOptionsUserActivityDictionaryKey"] != nil;
-  // Add a boolean to the initialProperties to let the app know you got the initial shortcut
-  NSDictionary *initialProperties = @{ @"launchedFromShortcut":@(launchedFromShortcut) };
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"example"
-                                            initialProperties:initialProperties]; // Add the initial properties here
+                                            initialProperties:nil];

  ...
}

 // This method checks for shortcuts issued to the app
 - (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
  restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler
{
-  UIViewController *viewController = [self.window rootViewController];
-  RCTRootView *rootView = (RCTRootView*) [viewController view];
-
-  // If the initial properties say the app launched from a shortcut (see above), tell the library about it.
-  if ([[rootView.appProperties objectForKey:@"launchedFromShortcut"] boolValue]) {
-    ShortcutsModule.initialUserActivity = userActivity;
-
-    rootView.appProperties = @{ @"launchedFromShortcut":@NO };
-  }
-
-  [ShortcutsModule onShortcutReceivedWithUserActivity:userActivity];
-
-  return YES;
+  return [RNSSSiriShortcuts application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}
```

## AddToSiriButton

### New Styles

`AddToSiriButton` now supports two extra styles introduced in iOS 13, `.automatic` and `.automaticOutline`. These two styles will use `.white`/`.black` depending on the user's device theme.

Since these styles were only introduced in iOS 13, devices on iOS 12 will default to `.white` and `.whiteOutline`, respectfully.

### Deprecated `supportsSiriButton`

`supportsSiriButton` was cumbersome to use and unintuitive. `AddToSiriButton` will now render `null` on platform's other than iOS, and on iOS versions prior to 12, by default.

### Import Change

`AddToSiriButton` and `SiriButtonStyles` are not named exports in `index.js`. This means you should import them like this from now on:

```javascript
import { AddToSiriButton, SiriButtonStyles } from "react-native-siri-shortcut";
```

## Shortcut Listener

Prior to v3, adding a shortcut listener when the app was opened via a shortcut would immediately trigger the listener.

Since this is not obvious behavior, since you could setup the listener later down the app's lifetime, therefore handling a shortcut that the user triggered long ago, this is no longer the observed behavior.

### `getInitialShortcut`

A new API for [`getInitialShortcut`](api/listening-for-shortcuts#getinitialshortcut) allows you to access the initial shortcut that launched the app.

### Deprecated `SiriShortcutsEvent`

`SiriShortcutsEvent` was replaced with [`addShortcutListener`](api/listening-for-shortcuts#addshortcutlistener).
