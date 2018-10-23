import { NativeModules, NativeEventEmitter, Platform } from "react-native";

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

// depreceated, please use donateShortcut
export const createShortcut = safeCall(opts =>
  donateShortcut(opts)
);

export const donateShortcut = safeCall(opts =>
  RNSiriShortcuts.donateShortcut(opts)
);

export const suggestShortcuts = safeCall(opts =>
  RNSiriShortcuts.suggestShortcuts(opts)
);

export const clearAllShortcuts = safeCall(
  RNSiriShortcuts.clearAllShortcuts
);

export const clearShortcutsWithIdentifiers = safeCall(
  RNSiriShortcuts.clearShortcutsWithIdentifiers
);
