import 'package:flutter/material.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';

class OverSlideAnimation extends OverAnimation {
  final Offset? begin;
  final Offset end;
  final Alignment? beginAlignment;
  const OverSlideAnimation({
    int? durationMilliseconds,
    int? reverseDurationMilliseconds,
    Curve? curve,
    Curve? reverseCurve,
    this.begin,
    this.beginAlignment,
    this.end = Offset.zero,
    OverAnimation? child,
  })  : assert(begin != null || beginAlignment != null),
        super(
          durationMilliseconds: durationMilliseconds,
          reverseDurationMilliseconds: reverseDurationMilliseconds,
          curve: curve,
          reverseCurve: reverseCurve,
          childAnimation: child,
        );

  Offset getBegin() => begin ?? Offset(beginAlignment!.x, beginAlignment!.y);
}
