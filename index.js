import { NativeModules, NativeEventEmitter } from "react-native";

const { RNSiriShortcuts } = NativeModules;

export const SiriShortcutsEvent = new NativeEventEmitter(RNSiriShortcuts);

export const createShortcut = opts => RNSiriShortcuts.setupShortcut(opts);
