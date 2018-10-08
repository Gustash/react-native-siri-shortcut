import { NativeModules, NativeEventEmitter } from "react-native";
import { Platform } from "react-native";

const RNSiriShortcuts = NativeModules.RNSiriShortcuts || {};

const noop = () => ({});
const safeCall = func =>
  Platform.select({
    android: noop,
    ios: func
  });

export const SiriShortcutsEvent = Platform.select({
  ios: new NativeEventEmitter(RNSiriShortcuts),
  android: {
    addListener: () => {}
  }
});

export const createShortcut = safeCall(opts =>
  RNSiriShortcuts.setupShortcut(opts)
);
export const clearAllShortcuts = safeCall(RNSiriShortcuts.clearAllShortcuts);
export const clearShortcutsWithIdentifiers = safeCall(
  RNSiriShortcuts.clearShortcutsWithIdentifiers
);
