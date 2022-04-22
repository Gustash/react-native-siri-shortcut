import React from "react";
import { EmitterSubscription, NativeEventEmitter, StyleProp, ViewStyle } from "react-native";

export type ShortcutOptions = {
  /** The activity type with which the user activity object was created. */
  activityType: string;
  /** An optional, user-visible title for this activity, such as a document name or web page title. */
  title?: string;
  /** A set of keys that represent the minimal information about the activity that should be stored for later restoration. */
  requiredUserInfoKeys?: Array<string>;
  /** A dictionary containing app-specific state information needed to continue an activity on another device. */
  userInfo?: { [key: string]: any };
  /** Indicates that the state of the activity needs to be updated. */
  needsSave?: boolean;
  /** A set of localized keywords that can help users find the activity in search results. */
  keywords?: Array<string>;
  /** A value used to identify the user activity. */
  persistentIdentifier?: string;
  /** A Boolean value that indicates whether the activity can be continued on another device using Handoff. */
  isEligibleForHandoff?: boolean;
  /** A Boolean value that indicates whether the activity should be added to the on-device index. */
  isEligibleForSearch?: boolean;
  /** A Boolean value that indicates whether the activity can be publicly accessed by all iOS users. */
  isEligibleForPublicIndexing?: boolean;
  /** The date after which the activity is no longer eligible for Handoff or indexing. In ms since Unix Epox */
  expirationDate?: number;
  /** Webpage to load in a browser to continue the activity. */
  webpageURL?: string;
  /** A Boolean value that determines whether Siri can suggest the user activity as a shortcut to the user. */
  isEligibleForPrediction?: boolean;
  /** A phrase suggested to the user when they create a shortcut. */
  suggestedInvocationPhrase?: string;
  /** Content type of this shorcut. Check available options at https://developer.apple.com/documentation/mobilecoreservices/uttype/uti_abstract_types */
  contentType?: string;
  /** An optional description for the shortcut. */
  description?: string;
};

export type PresentShortcutCallbackData = {
  status: "cancelled" | "added" | "deleted" | "updated";
  phrase: string | undefined;
};

export type ShortcutData = {
  identifier: string;
  phrase: string;
  options?: ShortcutOptions;
};

export type ShortcutInfo = {
  activityType: string;
  userInfo?: { [key: string]: any };
}

/** @deprecated Use `addShortcutListener` instead. */
export const SiriShortcutsEvent: NativeEventEmitter;

export function getInitialShortcut(): Promise<ShortcutInfo | null>;

export type ShortcutListener = (shortcut: ShortcutInfo) => void;
export function addShortcutListener(callback: ShortcutListener): EmitterSubscription;

export function donateShortcut(options: ShortcutOptions): void;

export function suggestShortcuts(options: Array<ShortcutOptions>): void;

export function presentShortcut(
  options: ShortcutOptions,
  callback: (data: PresentShortcutCallbackData) => void
): void;

export function getShortcuts(): Promise<Array<ShortcutData>>;

export function clearAllShortcuts(): Promise<void>;

export function clearShortcutsWithIdentifiers(
  identifierArray: Array<string>
): Promise<void>;

export const supportsPresentShortcut: boolean;

export enum SiriButtonStyles {
  white = 0,
  whiteOutline = 1,
  black = 2,
  blackOutline = 3,
  /** Only supported on iOS >= 13. On iOS 12 this defaults to `white` */
  automatic = 4,
  /** Only supported on iOS >= 13. On iOS 12 this defaults to `whiteOutline` */
  automaticOutline = 5,
}
export interface AddToSiriButtonProps {
  buttonStyle?: SiriButtonStyles;
  style?: StyleProp<ViewStyle>;
  shortcut: ShortcutOptions;
  onPress?: () => void;
}
export const AddToSiriButton: (props: AddToSiriButtonProps) => JSX.Element | null;
