import 'dart:math';

import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';
import 'package:overlayment/src/controllers/notification_controller.dart';

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
    var result = widget.overlay.child;

    // add basis decorations
    result = Material(
      key: containerKey,
      color: Colors.transparent,
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
        child: result,
      ),
    );

    if (widget.overlay.addInsetsPaddings) {
      result = Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: result,
      );
    }
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
      var widgetPosition = widget.position(_size, _movingPosition);
      if (widget.overlay is OverNotification && _size != null) {
        widgetPosition = NotificationController.instance.fixPosition(
          widget.overlay.name,
          widgetPosition,
          _size!,
          context,
        );
      }
      result = Positioned(
        left: widgetPosition.dx,
        top: widgetPosition.dy,
        width: _getWidth(widgetPosition),
        height: _getHeight(widgetPosition),
        child: result,
      );
    }

    // wrap every thing in a SafeArea
    return result;
  }

  /// correct width if the widget will be outside of the screen
  double? _getWidth(Offset position) {
    final w = widget.width();
    // nothing to correct
    if (_size == null || _size!.width == 0) return w;

    final screenWidth = MediaQuery.of(context).size.width;
    final currentWidth = w ?? _size!.width;

    if (position.dx + currentWidth > screenWidth) {
      return screenWidth - position.dx;
    }
    return currentWidth;
  }

  /// correct height if the widget will be outside of the screen
  double? _getHeight(Offset position) {
    final h = widget.height();
    // nothing to correct
    if (_size == null || _size!.height == 0) return h;

    final screenHeight = MediaQuery.of(context).size.height;
    final currentHeight = h ?? _size!.height;

    if (position.dy + currentHeight > screenHeight) {
      return screenHeight - position.dy;
    }
    return currentHeight;
  }

  double? get width {
    final w = widget.width();
    if (w == null || _size == null) return w;
    return max(w, _size!.width);
  }

  double? get height {
    final h = widget.height();
    if (h == null || _size == null) return h;
    return max(h, _size!.height);
  }
}
