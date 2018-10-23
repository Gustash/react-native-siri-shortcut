/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */
import React, { Component } from "react";
import {
  Platform,
  StyleSheet,
  Text,
  View,
  NativeModules,
  Button,
  NativeEventEmitter
} from "react-native";
import {
  SiriShortcutsEvent,
  donateShortcut,
  suggestShortcuts,
  clearAllShortcuts,
  clearShortcutsWithIdentifiers
} from "react-native-siri-shortcut";

const opts1 = {
  activityType: "com.github.gustash.SiriShortcutsExample.sayHello",
  title: "Say Hi",
  userInfo: {
    foo: 1,
    bar: "baz",
    baz: 34.5
  },
  keywords: ["kek", "foo", "bar"],
  persistentIdentifier: "com.github.gustash.SiriShortcutsExample.sayHello",
  isEligibleForSearch: true,
  isEligibleForPrediction: true,
  suggestedInvocationPhrase: "Say something",
  needsSave: true
};

const opts2 = {
  activityType: "com.github.gustash.SiriShortcutsExample.somethingElse",
  title: "Something Else",
  persistentIdentifier: "some.persistent.identifier",
  isEligibleForSearch: true,
  isEligibleForPrediction: true,
  suggestedInvocationPhrase: "What's up?"
};

type Props = {};
type State = {
  shortcutInfo: ?any,
  shortcutActivityType: ?string
};
export default class App extends Component<Props, State> {
  state = {
    shortcutInfo: null,
    shortcutActivityType: null
  };

  componentDidMount() {
    SiriShortcutsEvent.addListener(
      "SiriShortcutListener",
      this.handleSiriShortcut.bind(this)
    );

    // This will suggest these two shortcuts so that they appear
    // in Settings > Siri & Search, even if they are not yet
    // donated. Suitable for shortcuts that you expect the user 
    // may want to use. (https://developer.apple.com/documentation/sirikit/shortcut_management/suggesting_shortcuts_to_users)
    suggestShortcuts([
      opts1,
      opts2
    ]);
  }

  componentDidUpdate() {
    alert("I got a shortcut!");
  }

  handleSiriShortcut({ userInfo, activityType }: any) {
    this.setState({
      shortcutInfo: userInfo,
      shortcutActivityType: activityType
    });
  }

  setupShortcut1() {
    createShortcut(opts1);
  }

  setupShortcut2() {
    createShortcut(opts2);
  }

  async clearShortcut1() {
    try {
      await clearShortcutsWithIdentifiers([
        "com.github.gustash.SiriShortcutsExample.sayHello"
      ]);
      alert("Cleared Shortcut 1");
    } catch (e) {
      alert("You're not running iOS 12!");
    }
  }

  async clearShortcut2() {
    try {
      await clearShortcutsWithIdentifiers(["some.persistent.identifier"]);
      alert("Cleared Shortcut 2");
    } catch (e) {
      alert("You're not running iOS 12!");
    }
  }

  async clearBothShortcuts() {
    try {
      await clearShortcutsWithIdentifiers([
        "com.github.gustash.SiriShortcutsExample.sayHello",
        "some.persistent.identifier"
      ]);
      alert("Cleared Both Shortcuts");
    } catch (e) {
      alert("You're not running iOS 12!");
    }
  }

  async clearShortcuts() {
    try {
      await clearAllShortcuts();
      alert("Deleted all the shortcuts");
    } catch (e) {
      alert("You're not running iOS 12!");
    }
  }

  render() {
    const { shortcutInfo, shortcutActivityType } = this.state;

    return (
      <View style={styles.container}>
        <Text>Shortcut Activity Type: {shortcutActivityType || "None"}</Text>
        <Text>
          Shortcut Info:{" "}
          {shortcutInfo ? JSON.stringify(shortcutInfo) : "No shortcut data."}
        </Text>
        <Button
          title="Create Shortcut 1"
          onPress={this.setupShortcut1.bind(this)}
        />
        <Button
          title="Create Shortcut 2"
          onPress={this.setupShortcut2.bind(this)}
        />
        <Button
          title="Clear Shortcut 1"
          onPress={this.clearShortcut1.bind(this)}
        />
        <Button
          title="Clear Shortcut 2"
          onPress={this.clearShortcut2.bind(this)}
        />
        <Button
          title="Clear Both Shortcuts"
          onPress={this.clearBothShortcuts.bind(this)}
        />
        <Button
          title="Delete All Shortcuts"
          onPress={this.clearShortcuts.bind(this)}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#F5FCFF"
  },
  welcome: {
    fontSize: 20,
    textAlign: "center",
    margin: 10
  },
  instructions: {
    textAlign: "center",
    color: "#333333",
    marginBottom: 5
  }
});
