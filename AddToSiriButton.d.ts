import * as React from "react";
import { ViewStyle } from "react-native";
import { ShortcutOptions } from "./";

export const SiriButtonStyles: {
  white: 0;
  whiteOutline: 1;
  black: 2;
  blackOutline: 3;
};

type Props = {
  buttonStyle?: 0 | 1 | 2 | 3;
  style?: ViewStyle;
  shortcut: ShortcutOptions;
  onPress?: () => void;
};

declare const AddtoSiriButton: React.ComponentType<Props>;

export const supportsSiriButton: boolean;

export default AddtoSiriButton;
