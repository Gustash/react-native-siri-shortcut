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
  createShortcut,
  clearAllShortcuts
} from "react-native-siri-shortcut";

const opts = {
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

  setupShortcut() {
    createShortcut(opts);
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
          {shortcutInfo
            ? JSON.stringify(shortcutInfo)
            : "No shortcut was opened."}
        </Text>
        <Button
          title="Create Shortcut"
          onPress={this.setupShortcut.bind(this)}
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
