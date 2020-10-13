<a href="https://www.npmjs.com/package/react-native-siri-shortcut">
  <img src="https://img.shields.io/npm/v/react-native-siri-shortcut" />
</a>
<a href="https://www.npmjs.com/package/react-native-siri-shortcut">
  <img src="https://img.shields.io/npm/dm/react-native-siri-shortcut" />
</a>

# react-native-siri-shortcut

This module lets you use the new iOS 12 Siri Shortcuts inside your React Native app.

You can also use this for <iOS 12 User Activities.

### Android

This package is safe-guarded for Android, so you can freely call these functions and they won't crash your Android app. But be careful because the calls don't throw any errors, so don't always assume your action was actually successful if it doesn't error out. Always check if, in case of success, the platform is iOS.

## Getting started

### The easy way (use_frameworks!)

Just install the package.

`$ npm install react-native-siri-shortcut --save`

Add `use_frameworks!` under your target in your `Podfile`.

Run `pod install` in the `ios/` directory.

Done. Skip to the changes in `AppDelegate.m`.

### The not-so-easy way

If you can't use `use_frameworks!`, install the package:

`$ npm install react-native-siri-shortcut --save`

Create a Bridging Header file:

Add a new file to Xcode (File > New > File), then select “Source” and click “Swift File“.

Name it anything you want. Select "Yes" when asked if you want to create a Bridging Header File.

Delete everything in the new Swift file.

Run `pod install` in the `ios/` directory.

### If you have React Native <= 0.60

Manually link the package.

`$ react-native link react-native-siri-shortcut`

Run `pod install` in the `ios/` directory.

### Changes to the AppDelegate.m

Add these lines to your AppDelegate.m to get shortcut data from a cold-launch.

```objectivec
// AppDelegate.m

// ... imports
@import RNSiriShortcuts;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  ...

  // Check if the app launched with any shortcuts
  BOOL launchedFromShortcut = [launchOptions objectForKey:@"UIApplicationLaunchOptionsUserActivityDictionaryKey"] != nil;
  // Add a boolean to the initialProperties to let the app know you got the initial shortcut
  NSDictionary *initialProperties = @{ @"launchedFromShortcut":@(launchedFromShortcut) };
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"example"
                                            initialProperties:initialProperties]; // Add the initial properties here

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

## Usage

```javascript
import {
  SiriShortcutsEvent,
  donateShortcut,
  suggestShortcuts,
  clearAllShortcuts,
  clearShortcutsWithIdentifiers,
} from "react-native-siri-shortcut";
import AddToSiriButton, {
  SiriButtonStyles
} from "react-native-siri-shortcut/AddToSiriButton";

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
          <AddToSiriButton
            style={{ flex: 1 }}
            buttonStyle={SiriButtonStyles.whiteOutline}
            onPress={() => {
              console.log("You clicked me");
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
  suggestedInvocationPhrase?: string,
  /** Content type of this shorcut. Check available options at https://developer.apple.com/documentation/mobilecoreservices/uttype/uti_abstract_types */
  contentType?: string,
  /** An optional description for the shortcut. */
  description?: string,
};
```

### Callback Type for the `presentShortcut` function

```javascript
type PresentShortcutCallbackData = {
  status: "cancelled" | "added" | "deleted" | "updated",
};
```

### Data Type for `getShortcuts` function

```javascript
type ShortcutData = {
  identifier: string,
  phrase: string,
  options?: ShortcutOptions,
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

#### Remove listener on cleanup

```javascript
SiriShortcutsEvent.removeListener(
  "SiriShortcutListener",
  ({ userInfo, activityType }) => {
    // Do something with userInfo and/or activityType
  }
);
```

### Donate shortcut

#### Previously `createShortcut` which is now deprecated, use this instead.

Donate shortcut for an activity each time the user does it. For example, each time the user orders soup you may want to donate an activity that is relevant to ordering soup. Siri will use this information to then potentially recommend this activity to the user in their spotlight etc. These recommendations are based on factors such as time and location. _Do not_ donate an activity if the user hasn't done it.

```javascript
donateShortcut((options: ShortcutOptions));
```

### Suggest shortcuts

Suggest shortcut for an activity if you would like an activity to appear in Siri Shortcuts without the user having to do it and thus before you'd donate it. This is geared towards more general actions that you believe users may want to use in Shortcuts even if they haven't made use of it in your app.

```javascript
suggestShortcuts((shortcuts: Array<ShortcutOptions>));
```

### Clear all shortcuts

```javascript
/* ES5 */

clearAllShortcuts()
  .then(() => {
    // Successfully cleared
  })
  .catch((e) => {
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

clearShortcutsWithIdentifiers((identifierArray: Array<string>))
  .then(() => {
    // Successfully cleared
  })
  .catch((e) => {
    // Can't clear on <iOS 12
  });

/* ES6 */

try {
  await clearShortcutsWithIdentifiers((identifierArray: Array<string>));
  // Successfully cleared
} catch (e) {
  // Can't clear on <iOS 12
}
```

### Get recorded shortcuts

```javascript
/* ES5 */

getShortcuts((shortcuts: Array<ShortcutData>))
  .then(() => {
    // Handle list of shortcuts
  })
  .catch((e) => {
    // Can't get list on <iOS 12
  });

/* ES6 */

try {
  await getShortcuts((shortcuts: Array<ShortcutData>));
  // Handle list of shortcuts
} catch (e) {
  // Can't get list on <iOS 12
}
```

### Add to Siri button

```javascript
<AddToSiriButton
  style={style: ViewStyleProps}
  buttonStyle={SiriButtonStyles.white: 0 | 1 | 2 | 3} // Recommended you use the exported SiriButtonStyles object
  onPress={() => {
    console.log('I was pressed!')
  }: () => void}
  shortcut={options: ShortcutOptions}
/>
```

#### Check if the button is available

```javascript
import { supportsSiriButton } from "react-native-siri-shortcut/AddToSiriButton";

{
  supportsSiriButton && <AddToSiriButton {...props} />;
}
```

#### Black Theme

![Black Theme](https://developer.apple.com/design/human-interface-guidelines/siri/images/AddToSiri-Black.png)

#### Black Outline Theme

![Black Outline Theme](https://developer.apple.com/design/human-interface-guidelines/siri/images/AddToSiri-Black-Outlined.png)

#### White Theme

![White Theme](https://developer.apple.com/design/human-interface-guidelines/siri/images/AddToSiri-White.png)

#### White Outline Theme

![White Outline Theme](https://developer.apple.com/design/human-interface-guidelines/siri/images/AddToSiri-White-Outlined.png)

### Present shortcut

This will open a screen prompting the user to create a custom phrase to add the shortcut provided to Siri. If the user has already added the shortcut before, the screen will give them the option to either update or delete the shortcut from their Siri.

```javascript
presentShortcut(
  (options: ShortcutOptions),
  (callback: () => PresentShortcutCallbackData)
);
```

![Example Screen](https://support.apple.com/library/content/dam/edam/applecare/images/en_US/iOS/ios12-iphone-x-third-party-app-add-to-siri.jpg)

## Example project

Feel free to clone this repo and run the `example/` project.

Run `npm install` or `yarn install` in the `example/` directory.

Run `pod install` in the `example/ios/` directory.

Build the app in XCode.
