import 'package:flutter/material.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';

import '../../overlayment.dart';
import 'animations/overlay_animation.dart';

mixin OverlayBase {
  /// {@template overlay_base.name}
  /// a unique name for the overlay. If you don't set a name, the overlay
  /// will be named with the class name. You can use this name to close the overlay later
  /// {@endtemplate}
  String get name;

  /// {@template overlay_base.animation}
  /// The animation that will be used to show the overlay.
  /// You can use [OverFadeAnimation], [OverSlideAnimation] or [OverScaleAnimation]
  /// {@endtemplate}
  OverAnimation get animation;

  /// {@template overlay_base.color}
  /// The overlay background color. If the [decoration] is set, this property
  /// will be ignored.
  /// {@endtemplate}
  Color? get color;

  /// {@template overlay_base.margin}
  /// the overlay margin
  /// {@endtemplate}
  EdgeInsets? get margin;

  /// {@template overlay_base.decoration}
  /// The overlay decoration.
  /// {@endtemplate}
  BoxDecoration? get decoration;

  /// the animation when the overlay is shown
  OverlayAnimation get overlayAnimation;
  set overlayAnimation(OverlayAnimation value);

  /// this widget to show in the overlay
  Widget get child;

  /// {@template overlay_base.actions}
  /// set custom actions to the overlay events. See [OverlayActions] for more details
  /// {@endtemplate}
  OverlayActions get actions;

  /// {@template overlay_base.duration}
  /// the time to keep the overlay open.
  /// When the time is over, the overlay will be closed automatically.
  /// If the value is null, the overlay will not be closed automatically.
  /// {@endtemplate}
  Duration? get duration;

  /// {@template overlay_base.addInsetsPaddings}
  /// This will defines if the overlay should have the insets padding of the device
  /// This is used for example to move the overly if the keyboard is opened
  /// This is true as default for OverPanels and Expanders and false for the rest
  /// {@endtemplate}
  bool get addInsetsPaddings;

  List<OverlayEntry> buildEntries();

  /// show this overlay
  Future<T?> show<T>({BuildContext? context});
}
