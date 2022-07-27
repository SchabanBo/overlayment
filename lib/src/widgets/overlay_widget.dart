import 'dart:math';

import 'package:flutter/material.dart';

import '../types/animations/overlay_animation.dart';
import '../types/overlay_base.dart';

class OverlayWidget extends StatefulWidget {
  final OverlayBase overlay;
  final double? Function() height;
  final double? Function() width;
  final Offset Function(Size?, Offset?) position;
  final Alignment? alignment;
  final bool canMoved;

  const OverlayWidget({
    required this.overlay,
    required this.position,
    required this.height,
    required this.width,
    this.canMoved = false,
    this.alignment,
    Key? key,
  }) : super(key: key);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget>
    with TickerProviderStateMixin {
  final containerKey = GlobalKey();
  Size? _size;
  @override
  void initState() {
    widget.overlay.overlayAnimation = OverlayAnimation.of(
        animation: widget.overlay.animation, tickerProvider: this);
    super.initState();

    if (widget.overlay.actions.onOpen != null) {
      widget.overlay.actions.onOpen!();
    }

    widget.overlay.overlayAnimation.forward().then((value) {
      if (widget.overlay.actions.onReady != null) {
        widget.overlay.actions.onReady!();
      }
    });
  }

  void _updateSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (containerKey.currentContext != null) {
        final containerSize = containerKey.currentContext!.size;
        if (_size == null) {
          _size = containerSize;
          setState(() {});
        } else {
          _size = containerSize;
        }
      }
    });
  }

  Offset? _movingPosition;

  @override
  Widget build(BuildContext context) {
    _updateSize();
    var result = child;

    // if widget can be moved then add GestureDetector to update position
    if (widget.canMoved) {
      result = GestureDetector(
        onPanUpdate: (details) {
          final size = containerKey.currentContext!.size!;
          _movingPosition = Offset(details.globalPosition.dx - size.width / 2,
              details.globalPosition.dy - size.height * 0.2);
          setState(() {});
        },
        child: result,
      );
    }

    // add the widget animation
    result = widget.overlay.overlayAnimation.build(result);

    // if the widget should be aligned then add alignment
    if (widget.alignment != null) {
      result = Align(
        alignment: widget.alignment!,
        child: SizedBox(
          width: width,
          height: height,
          child: result,
        ),
      );
    } else {
      // else calc and add position
      final widgetPosition = widget.position(_size, _movingPosition);
      result = Positioned(
        left: widgetPosition.dx,
        top: widgetPosition.dy,
        width: width,
        height: height,
        child: result,
      );
    }

    // wrap every thing in a SafeArea
    return result;
  }

  double? get width {
    final w = widget.width();
    if (w == null || _size == null) {
      return w;
    }
    return max(w, _size!.width);
  }

  double? get height {
    final h = widget.height();
    if (h == null || _size == null) {
      return h;
    }
    return max(h, _size!.height);
  }

  Widget get child => SafeArea(
        child: Material(
          color: Colors.transparent,
          key: containerKey,
          child: Container(
            margin: widget.overlay.margin,
            decoration: widget.overlay.decoration ??
                BoxDecoration(
                  color: widget.overlay.color ??
                      Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
            child: widget.overlay.child,
          ),
        ),
      );
}
