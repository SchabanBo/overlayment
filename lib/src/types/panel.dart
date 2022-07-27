import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';
import 'package:overlayment/src/types/overlay_base.dart';

import '../../overlayment.dart';
import '../widgets/filter_widget.dart';
import '../widgets/overlay_widget.dart';
import 'animations/overlay_animation.dart';

/// Show a panel
/// ```dart
///Overlayment.show(
///   OverPanel(
///     child: Text('This is a panel'),
///     alignment: Alignment.bottomCenter,
///   )
///)
class OverPanel with OverlayBase {
  OverPanel({
    required this.child,
    this.alignment = Alignment.bottomCenter,
    this.offset = Offset.zero,
    this.actions = const OverlayActions(),
    OverAnimation? animation,
    this.margin,
    this.height,
    this.decoration,
    this.backgroundSettings = const BackgroundSettings(),
    this.width,
    this.duration,
    this.color,
    String? name,
    Key? key,
  }) : name = name ?? 'Panel${child.hashCode}' {
    this.animation = animation ?? OverSlideAnimation(begin: getBegin());
  }

  /// The Position where the panel should displayed
  final Alignment alignment;

  /// {@macro Overlayment.BackgroundSettings}
  final BackgroundSettings? backgroundSettings;

  /// The panel height
  final double? height;

  /// The offset from the panel position. With this offset, you can move
  /// the panel position for example for up or down left or right
  final Offset offset;

  /// The panel width
  final double? width;

  /// {@macro overlay_base.actions}
  @override
  final OverlayActions actions;

  /// {@macro overlay_base.animation}
  @override
  late final OverAnimation animation;

  /// The content of your Panel
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
          builder: (context) => FilterWidget(
            this,
            backgroundSettings!,
            animation,
          ),
        ),
      OverlayEntry(
        builder: (context) => OverlayWidget(
          overlay: this,
          height: () => _getHeight(MediaQuery.of(context).size),
          width: () => _getWidth(MediaQuery.of(context).size),
          alignment: alignment,
          position: (s, _) => Offset.zero,
        ),
      )
    ];
  }

  @override
  Future<T?> show<T>({BuildContext? context}) =>
      Overlayment.show(this, context: context);

  Offset getBegin() {
    if (alignment.x != 0.0) return Offset(alignment.x, 0.0);

    if (alignment.y == 0.0 && alignment.y == 0.0) {
      return const Offset(0.0, 5);
    }

    return Offset(0.0, alignment.y);
  }

  double? _getWidth(Size screen) {
    if (width != null) return width;
    if (alignment.x != 0) return screen.width * 0.3;
    if (alignment.x == 0 && alignment.y == 0) return screen.width * 0.4;
    if (alignment.x == 0 && alignment.y != 0) return screen.width;
    return null;
  }

  double? _getHeight(Size screen) {
    if (height != null) return height;
    if (alignment.x != 0 && alignment.y == 0) return screen.height;
    return null;
  }
}
