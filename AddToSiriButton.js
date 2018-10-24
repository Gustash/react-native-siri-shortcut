import React from "react";
import { requireNativeComponent, View } from "react-native";

const RNTAddToSiriButton = requireNativeComponent("RNTAddToSiriButton", null);

export const SiriButtonStyles = {
  white: 0,
  whiteOutline: 1,
  black: 2,
  blackOutline: 3
};

// TODO: Add PropTypes
const AddToSiriButton = ({ buttonStyle = SiriButtonStyles.white }) => (
  <View style={{ width: 150, height: 56 }}>
    <RNTAddToSiriButton style={{ flex: 1 }} buttonStyle={buttonStyle} />
  </View>
);

export default AddToSiriButton;
