import { NativeModules, NativeEventEmitter, Platform } from "react-native";

const RNSiriShortcuts = NativeModules.RNSiriShortcuts || {};

export type ShortcutOptions = {
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

export type PresentShortcutCallbackData = {
  status: "cancelled" | "added" | "deleted" | "updated",
  phrase: ?string
};

export type ShortcutData = {
  identifier: string,
  phrase: string,
  options?: ShortcutOptions
};

const noop = () => ({});
const safeCall = (func, minVersion = 12) => {
  if (
    Platform.OS !== "ios" ||
    Number.parseFloat(Platform.Version, 10) < minVersion
  ) {
    return noop;
  }

  return func;
};

export const SiriShortcutsEvent = Platform.select({
  ios: new NativeEventEmitter(RNSiriShortcuts),
  android: {
    addListener: () => {},
    removeListener: () => {},
    removeAllListeners: () => {},
    removeCurrentListener: () => {},
    removeSubscription: () => {},
    listeners: () => {}
  }
});

/**
 * @deprecated Please use `donateShortcut` instead.
 */
export const createShortcut = (opts: ShortcutOptions) => donateShortcut(opts);

export const donateShortcut = safeCall(
  (opts: ShortcutOptions) => RNSiriShortcuts.donateShortcut(opts),
  9
);

export const suggestShortcuts = safeCall((opts: Array<ShortcutOptions>) =>
  RNSiriShortcuts.suggestShortcuts(opts)
);

export const clearAllShortcuts = safeCall(() =>
  RNSiriShortcuts.clearAllShortcuts()
);

export const clearShortcutsWithIdentifiers = safeCall(
  (identifiers: Array<string>) =>
    RNSiriShortcuts.clearShortcutsWithIdentifiers(identifiers)
);

export const supportsPresentShortcut =
  Platform.OS === "ios" && Number.parseFloat(Platform.Version) >= 12;

export const presentShortcut = safeCall(
  (opts: ShortcutOptions, callback: () => PresentShortcutCallbackData) =>
    RNSiriShortcuts.presentShortcut(opts, callback)
);

export const getShortcuts = safeCall(() => RNSiriShortcuts.getShortcuts());
