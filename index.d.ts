import React from "react";
import { EmitterSubscription, NativeEventEmitter, StyleProp, ViewStyle } from "react-native";

export type ShortcutOptions = {
  activityType: string;
  title?: string;
  requiredUserInfoKeys?: Array<string>;
  userInfo?: any;
  needsSave?: boolean;
  keywords?: Array<string>;
  persistentIdentifier?: string;
  isEligibleForHandoff?: boolean;
  isEligibleForSearch?: boolean;
  isEligibleForPublicIndexing?: boolean;
  expirationDate?: number;
  webpageURL?: string;
  isEligibleForPrediction?: boolean;
  suggestedInvocationPhrase?: string;
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
