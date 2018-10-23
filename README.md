# react-native-siri-shortcut

This module lets you use the new iOS 12 Siri Shortcuts inside your React Native app.

You can also use this for <iOS 12 User Activities.

## Disclaimer

This project is in it's very early stages. I am adding features and fixing things
as I have time to work on them. If you have anything you want added, feel free to
do a Pull Request detailing your changes and why.

### Android

This package is safe-guarded for Android, so you can freely call these functions and they won't crash your Android app. But be careful because the calls don't throw any errors, so don't always assume your action was actually successful if it doesn't error out. Always check if, in case of success, the platform is iOS.

## Getting started

Install the module and react-native-swift (needed to support Swift code execution)

`$ npm install react-native-siri-shortcut react-native-swift --save`

### Mostly automatic installation

Link the package:

`$ react-native link react-native-siri-shortcut && react-native link react-native-swift`

Add these lines to your AppDelegate.m to get shortcut data from a cold-launch.

```objectivec
// AppDelegate.m

// ... imports
#import <RNSiriShortcuts/RNSiriShortcuts-Swift.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...

  // Check if the app launched with any shortcuts
  BOOL launchedFromShortcut = [launchOptions objectForKey:@"UIApplicationLaunchOptionsUserActivityDictionaryKey"] != nil;
  // Add a boolean to the initialProperties to let the app know you got the initial shortcut
  NSDictionary *initialProperties = @{ @"launchedFromShortcut":@(launchedFromShortcut) };

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"example"
                                               initialProperties:initialProperties // Add the initial properties here
                                                   launchOptions:launchOptions];

  ...
}

// This method checks for shortcuts issued to the app
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler
{
  UIViewController *viewController = [self.window rootViewController];
  RCTRootView *rootView = (RCTRootView*) [viewController view];

  // If the initial properties say the app launched from a shortcut (see above), tell the library about it.
  if ([[rootView.appProperties objectForKey:@"launchedFromShortcut"] boolValue]) {
    ShortcutsModule.initialUserActivity = userActivity;

    rootView.appProperties = @{ @"launchedFromShortcut":@NO };
  }

  [ShortcutsModule onShortcutReceivedWithUserActivity:userActivity];

  return YES;
}
```

- Enable the Siri capabilities for your project in the Capabilities tab.
- Go to you Info.plist and add a new key `NSUserActivityTypes` of type `Array`
  and add your different activity types as `String`.

### Manual installation

TODO: Detail manual installation process.

## Usage

```javascript
import {
  SiriShortcutsEvent,
  donateShortcut,
  suggestShortcuts,
  clearAllShortcuts,
  clearShortcutsWithIdentifiers
} from "react-native-siri-shortcut";

const opts = {
  activityType: "your.bundle.identifier.YourActionType", // This activity type needs to be set in `NSUserActivityTypes` on the Info.plist
  title: "Say Hi",
  userInfo: {
    foo: 1,
    bar: "baz",
    baz: 34.5
  },
  keywords: ["kek", "foo", "bar"],
  persistentIdentifier: "yourPersistentIdentifier",
  isEligibleForSearch: true,
  isEligibleForPrediction: true,
  suggestedInvocationPhrase: "Say something",
  needsSave: true
};

// The registered component in index.js (application start point)
class App extends Component {
    ...

    componentDidMount() {
        SiriShortcutsEvent.addListener(
            "SiriShortcutListener",
            ({ userInfo, activityType }) => {
                // Do something with the userInfo and/or activityType
            }
        );

        suggestShortcuts([opts]);
    }

    render() {
        return (
          <Button
            title="Donate Shortcut"
            onPress={() => donateShortcut(opts)}
          />
          <Button
            title="Clear Shortcuts With Identifiers"
            onPress={async () => {
              try {
                await clearShortcutsWithIdentifiers([
                  "some.identifier",
                  "another.identifier"
                ]);
                // Shortcuts cleared
              } catch (e) {
                // Can't clear shortcuts on <iOS 12 because they don't exist
              }
            }}
          />
          <Button
            title="Clear All Shortcuts"
            onPress={async () => {
              try {
                await clearAllShortcuts();
                // Shortcuts were successfully cleared
              } catch (e) {
                // Can't clear shortcuts on <iOS 12 because they don't exist
              }
            }}
          />
        );
    }

    ...
}
```

## API

### Shortcut Options type

```javascript
type ShortcutOptions = {
  /** The activity type with which the user activity object was created. */
  activityType: string,
  /** An optional, user-visible title for this activity, such as a document name or web page title. */
  title?: string,
  /** A set of keys that represent the minimal information about the activity that should be stored for later restoration. */
  requiredUserInfoKeys?: Array<string>,
  /** A dictionary containing app-specific state information needed to continue an activity on another device. */
  userInfo?: any,
  /** Indicates that the state of the activity needs to be updated. */
  needsSave?: boolean,
  /** A set of localized keywords that can help users find the activity in search results. */
  keywords?: Array<string>,
  /** A value used to identify the user activity. */
  persistentIdentifier?: string,
  /** A Boolean value that indicates whether the activity can be continued on another device using Handoff. */
  isEligibleForHandoff?: boolean,
  /** A Boolean value that indicates whether the activity should be added to the on-device index. */
  isEligibleForSearch?: boolean,
  /** A Boolean value that indicates whether the activity can be publicly accessed by all iOS users. */
  isEligibleForPublicIndexing?: boolean,
  /** The date after which the activity is no longer eligible for Handoff or indexing. In ms since Unix Epox */
  expirationDate?: number,
  /** Webpage to load in a browser to continue the activity. */
  webpageURL?: string,
  /** A Boolean value that determines whether Siri can suggest the user activity as a shortcut to the user. */
  isEligibleForPrediction?: boolean,
  /** A phrase suggested to the user when they create a shortcut. */
  suggestedInvocationPhrase?: string
};
```

### Shortcut listener

```javascript
SiriShortcutsEvent.addListener(
  "SiriShortcutListener",
  ({ userInfo, activityType }) => {
    // Do something with userInfo and/or activityType
  }
);
```

### Donate shortcut

#### Previously `createShortcut` which is now deprecated, use this instead.

```javascript
donateShortcut(options: ShortcutOptions);
```

### Suggest shortcuts

#### Use this if you want to add the shortcut to Settings, but you don't want it to be suggested to the user.

```javascript
suggestShortcuts(shortcuts: Array<ShortcutOptions>);
```

### Clear all shortcuts

```javascript
/* ES5 */

clearAllShortcuts()
  .then(() => {
    // Successfully cleared
  })
  .catch(e => {
    // Can't clear on <iOS 12
  });

/* ES6 */

try {
  await clearAllShortcuts();
  // Successfully cleared
} catch (e) {
  // Can't clear on <iOS 12
}
```

### Clear shortcuts with identifiers

```javascript
/* ES5 */

clearShortcutsWithIdentifiers(identifierArray: Array<string>)
  .then(() => {
    // Successfully cleared
  })
  .catch(e => {
    // Can't clear on <iOS 12
  });

/* ES6 */

try {
  await clearShortcutsWithIdentifiers(identifierArray: Array<string>);
  // Successfully cleared
} catch (e) {
  // Can't clear on <iOS 12
}
```

## Example project

Feel free to clone this repo and run the `example/` project.

Just `npm install` or `yarn install` in the `example/` directory and start the
React Native app.
