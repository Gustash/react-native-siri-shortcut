// @flow
import type { ShortcutOptions } from ".";

import * as React from "react";
import {
  requireNativeComponent,
  View,
  Platform,
  UIManager,
  NativeModules,
} from "react-native";

const RNTAddToSiriButton = requireNativeComponent("RNSSAddToSiriButton");
const Constants = (
  UIManager.getViewManagerConfig
    ? UIManager.getViewManagerConfig("RNSSAddToSiriButton")
    : UIManager["RNSSAddToSiriButton"]
).Constants;

export const SiriButtonStyles = Constants.AvailableStyles;

type ViewProps = React.ElementConfig<typeof View>;
type ViewStyleProp = $PropertyType<ViewProps, "style">;

type Props = {
  buttonStyle?: 0 | 1 | 2 | 3 | 4 | 5,
  style?: ViewStyleProp,
  shortcut: ShortcutOptions,
  onPress?: () => void,
};

/** @deprecated The component itself now returns `null` when the device does not support the AddToSiriButton */
export const supportsSiriButton = Number.parseFloat(Platform.Version, 10) >= 12;

const AddToSiriButton = ({ buttonStyle, onPress, shortcut, style }: Props) => {
  if (!supportsSiriButton) {
    return null;
  }

  return (
  <RNTAddToSiriButton
    buttonStyle={buttonStyle}
    onPress={onPress}
    shortcut={shortcut}
    style={[
      {
        height: Constants.ComponentHeight,
        width: Constants.ComponentWidth,
      },
      style,
    ]}
  />
)};

export default AddToSiriButton;
