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
import { SiriShortcutsEvent, createShortcut } from "react-native-siri-shortcut";

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

type Props = {
  initialShortcutUserInfo: ?any,
  launchedFromShortcut: boolean
};
type State = {
  shortcutInfo: ?any
};
export default class App extends Component<Props, State> {
  constructor(props: Props) {
    super(props);

    this.handleSiriShortcut = this.handleSiriShortcut.bind(this);
  }

  state = {
    shortcutInfo: this.props.initialShortcutUserInfo
  };

  componentDidMount() {
    SiriShortcutsEvent.addListener(
      "SiriShortcutListener",
      this.handleSiriShortcut
    );
  }

  handleSiriShortcut({ userInfo }: any) {
    this.setState({
      shortcutInfo: userInfo
    });
  }

  setupShortcut() {
    createShortcut(opts);
  }

  render() {
    const { shortcutInfo } = this.state;

    return (
      <View style={styles.container}>
        <Text>
          Shortcut Info:{" "}
          {shortcutInfo
            ? JSON.stringify(shortcutInfo)
            : "No shortcut was opened."}
        </Text>
        <Button title="Create Shortcut" onPress={() => this.setupShortcut()} />
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
