import 'package:flutter/material.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';

class OverScaleAnimation extends OverAnimation {
  final double begin;
  final double end;
  final Alignment alignment;
  const OverScaleAnimation({
    int? durationMilliseconds = 300,
    int? reverseDurationMilliseconds = 300,
    Curve? curve = Curves.fastOutSlowIn,
    Curve? reverseCurve = Curves.fastOutSlowIn,
    this.begin = 0,
    this.alignment = Alignment.center,
    this.end = 1,
    OverAnimation? child,
  }) : super(
          durationMilliseconds: durationMilliseconds,
          reverseDurationMilliseconds: reverseDurationMilliseconds,
          curve: curve,
          reverseCurve: reverseCurve,
          childAnimation: child,
        );
}
