# react-native-siri-shortcut

This module lets you use the new iOS 12 Siri Shortcuts inside your React Native app.

You can also use this for <iOS 12 User Activities.

## Disclaimer

This project is in it's very early stages. I am adding features and fixing things
as I have time to work on them. If you have anything you want added, feel free to
do a Pull Request detailing your changes and why.

### This project only runs on iOS! It will crash on Android if you don't safe guard. I will add this to the library itself very soon.

## Getting started

Install the module and react-native-swift (needed to support Swift code execution)

`$ npm install react-native-siri-shortcut react-native-swift --save`

### Mostly automatic installation

Link the package:

`$ react-native link react-native-siri-shortcut && react-native link react-native-siri-shortcuts`

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
  createShortcut,
  clearAllShortcuts
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
    }

    render() {
        return (
          <Button
            title="Create Shortcut"
            onPress={() => createShortcut(opts)}
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

### Create shortcut

```javascript
createShortcut((options: ShortcutOptions));
```

### Clear shortcuts

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

## Example project

Feel free to clone this repo and run the `example/` project.

Just `npm install` or `yarn install` in the `example/` directory and start the
React Native app.
