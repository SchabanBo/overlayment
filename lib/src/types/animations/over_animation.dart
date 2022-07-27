import 'package:flutter/material.dart';

typedef OverAnimationBuilder = Widget Function(Widget child);

class OverAnimation {
  /// the animation Duration in Milliseconds when the notification opens
  final int durationMilliseconds;

  /// the reverse animation Duration in Milliseconds when the
  /// notification closes
  final int reverseDurationMilliseconds;

  /// The animation curve for the notification when opens
  final Curve curve;

  /// The animation curve for the notification when closes
  final Curve reverseCurve;

  /// a second animation to apply
  final OverAnimation? childAnimation;

  const OverAnimation({
    int? durationMilliseconds,
    int? reverseDurationMilliseconds,
    Curve? curve,
    Curve? reverseCurve,
    this.childAnimation,
  })  : durationMilliseconds = durationMilliseconds ?? 500,
        reverseDurationMilliseconds = reverseDurationMilliseconds ?? 500,
        curve = curve ?? Curves.fastLinearToSlowEaseIn,
        reverseCurve = reverseCurve ?? Curves.fastOutSlowIn;
}
