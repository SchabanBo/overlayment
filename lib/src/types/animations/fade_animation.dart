import 'package:flutter/cupertino.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';

class OverFadeAnimation extends OverAnimation {
  final double begin;
  final double end;
  const OverFadeAnimation({
    int? durationMilliseconds = 200,
    int? reverseDurationMilliseconds = 200,
    Curve? curve = Curves.linear,
    Curve? reverseCurve = Curves.linear,
    this.begin = 0,
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
