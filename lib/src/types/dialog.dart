import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';
import 'package:overlayment/src/types/overlay_base.dart';

import '../../overlayment.dart';
import '../widgets/filter_widget.dart';
import '../widgets/overlay_widget.dart';
import 'animations/overlay_animation.dart';

/// Show a dialog
class OverDialog with OverlayBase {
  OverDialog({
    required this.child,
    this.offset = Offset.zero,
    this.actions = const OverlayActions(),
    OverAnimation? animation,
    this.margin,
    this.height,
    this.decoration,
    this.backgroundSettings = const BackgroundSettings(blur: 1),
    this.width,
    this.duration,
    this.addInsetsPaddings = false,
    this.color,
    String? name,
    Key? key,
  }) : name = name ?? 'Panel${child.hashCode}' {
    this.animation =
        animation ?? const OverFadeAnimation(reverseDurationMilliseconds: 100);
  }

  /// {@macro Overlayment.BackgroundSettings}
  final BackgroundSettings? backgroundSettings;

  /// The dialog height, if null, the dialog will be fit to the content
  final double? height;

  /// The offset from the dialog position With this offset, you can move
  /// the dialog position for example for up or down left or right
  final Offset offset;

  /// The dialog width, if null, the dialog will be fit to the content
  final double? width;

  /// {@macro overlay_base.actions}
  @override
  final OverlayActions actions;

  /// {@macro overlay_base.addInsetsPaddings}
  @override
  final bool addInsetsPaddings;

  /// {@macro overlay_base.animation}
  @override
  late final OverAnimation animation;

  /// The content of your Dialog
  @override
  final Widget child;

  /// {@macro overlay_base.color}
  @override
  final Color? color;

  /// {@macro overlay_base.decoration}
  @override
  final BoxDecoration? decoration;

  /// {@macro overlay_base.duration}
  @override
  final Duration? duration;

  /// {@macro overlay_base.margin}
  @override
  final EdgeInsets? margin;

  /// {@macro overlay_base.name}
  @override
  final String name;

  @override
  late final OverlayAnimation overlayAnimation;

  @override
  List<OverlayEntry> buildEntries() {
    return [
      if (backgroundSettings != null)
        OverlayEntry(
          builder: (context) =>
              FilterWidget(this, backgroundSettings!, animation),
        ),
      OverlayEntry(
        builder: (context) => OverlayWidget(
          overlay: this,
          height: () => height,
          width: () => width,
          alignment: Alignment.center,
          position: (s, _) => Offset.zero,
        ),
      )
    ];
  }

  @override
  Future<T?> show<T>({BuildContext? context}) =>
      Overlayment.show(this, context: context);
}
