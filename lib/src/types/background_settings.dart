import 'package:flutter/material.dart';

/// {@template Overlayment.BackgroundSettings}
/// You can use this class to set the background [color] and  the background [blur]
/// of the layer behind the overlay.
/// if you set the [dismissOnClick] to true, the overlay will be dismissed when you on the background layer.
/// {@endtemplate}
class BackgroundSettings {
  const BackgroundSettings({
    this.color,
    this.blur,
    this.dismissOnClick = true,
  });

  factory BackgroundSettings.transparent([bool dismissOnClick = true]) =>
      BackgroundSettings(
        color: Colors.transparent,
        blur: null,
        dismissOnClick: dismissOnClick,
      );

  /// The background blur value.
  final double? blur;

  /// The background color.
  final Color? color;

  /// close the overlay if the user taps outside of it
  final bool dismissOnClick;
}
