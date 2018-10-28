// @flow
import type { ShortcutOptions } from ".";

import * as React from "react";
import { requireNativeComponent, View, StyleSheet } from "react-native";

const RNTAddToSiriButton = requireNativeComponent("RNTAddToSiriButton");

export const SiriButtonStyles = {
  white: 0,
  whiteOutline: 1,
  black: 2,
  blackOutline: 3
};

type ViewProps = React.ElementConfig<typeof View>;
type ViewStyleProp = $PropertyType<ViewProps, "style">;

type Props = {
  buttonStyle?: 0 | 1 | 2 | 3,
  style?: ViewStyleProp,
  shortcut: ShortcutOptions,
  onPress?: () => void
};

const AddToSiriButton = ({
  buttonStyle = SiriButtonStyles.white,
  style = {},
  onPress = () => {},
  shortcut
}: Props) => (
  <View
    style={[
      {
        width: 149,
        height: 50
      },
      style
    ]}
  >
    <RNTAddToSiriButton
      buttonStyle={buttonStyle}
      style={{ flex: 1 }}
      onPress={onPress}
      shortcut={shortcut}
    />
  </View>
);

export default AddToSiriButton;
