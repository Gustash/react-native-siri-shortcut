import { EmitterSubscription, NativeEventEmitter } from "react-native";

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
