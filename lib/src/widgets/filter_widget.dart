import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';
import 'package:overlayment/src/types/overlay_base.dart';

import '../../overlayment.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget(this.overlay, this.settings, this.animation, {Key? key})
      : super(key: key);

  final OverAnimation animation;
  final OverlayBase overlay;
  final BackgroundSettings settings;

  @override
  Widget build(BuildContext context) {
    if (!settings.dismissOnClick && settings.blur == null) {
      return Container();
    }

    Widget child = FutureBuilder(
      future: Future.microtask(() {}),
      builder: (_, s) => AnimatedContainer(
        duration: Duration(milliseconds: animation.durationMilliseconds),
        constraints: const BoxConstraints.expand(),
        color: s.connectionState == ConnectionState.done
            ? settings.color ?? Colors.black.withOpacity(0.1)
            : Colors.transparent,
      ),
    );
    if (settings.blur != null) {
      child = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: settings.blur!,
          sigmaY: settings.blur!,
        ),
        child: child,
      );
    }
    if (settings.dismissOnClick) {
      child = GestureDetector(
        onTap: () => Overlayment.dismiss(overlay),
        child: child,
      );
    }
    return child;
  }
}
