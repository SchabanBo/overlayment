import 'package:flutter/material.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';
import 'package:overlayment/src/types/overlay_base.dart';

import '../../overlayment.dart';
import '../widgets/overlay_widget.dart';
import 'animations/overlay_animation.dart';

/// Show a notification
/// ```dart
///Overlayment.show(OverNotification(
///    child: Text('This is a notification'),
///    alignment: Alignment.topCenter,
///    color: Colors.blue.shade200,
///));
/// ```
class OverNotification with OverlayBase {
  OverNotification({
    required this.child,
    this.offset = Offset.zero,
    this.alignment = Alignment.bottomRight,
    OverAnimation? animation,
    this.actions = const OverlayActions(),
    this.duration = const Duration(seconds: 2),
    this.height,
    this.width,
    this.color,
    this.margin = const EdgeInsets.all(8.0),
    this.decoration,
    this.addInsetsPaddings = false,
    String? name,
  }) : name = name ?? 'Notification${child.hashCode}' {
    this.animation = animation ?? OverSlideAnimation(begin: getBegin());
  }

  /// Show a simple notification with a title, message and an icon.
  factory OverNotification.simple({
    required String title,
    TextStyle titleStyle = const TextStyle(fontSize: 16),
    String? message,
    Widget? icon,
    bool withCloseButton = true,
    Offset offset = Offset.zero,
    Alignment alignment = Alignment.bottomRight,
    OverAnimation? animation,
    OverlayActions actions = const OverlayActions(),
    Duration duration = const Duration(seconds: 2),
    double? height,
    BoxDecoration? decoration,
    EdgeInsets? margin,
    double? width,
    Color? color,
    String? name,
  }) {
    Widget child = Text(title, style: titleStyle);
    name = name ?? 'Notification${child.hashCode}';
    if (withCloseButton) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          child,
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close',
            onPressed: () => Overlayment.dismissName(name!),
          ),
        ],
      );
    }
    if (message != null) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          Text(message),
        ],
      );
    }
    if (icon != null) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    return OverNotification(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
      offset: offset,
      alignment: alignment,
      animation: animation,
      actions: actions,
      duration: duration,
      height: height,
      decoration: decoration,
      margin: margin ?? const EdgeInsets.all(8.0),
      width: width,
      color: color,
      name: name,
    );
  }

  /// The Position where the notification should displayed in the screen
  final Alignment alignment;

  /// The notification height
  final double? height;

  /// The offset from the Notification position With this offset, you can move
  /// the notification position for example for up or down left or right
  final Offset offset;

  /// The Notification width
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

  /// The content of your notification
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
      OverlayEntry(
        builder: (context) => OverlayWidget(
          overlay: this,
          height: () => height,
          width: () => width,
          position: (s, _) => _calcPosition(MediaQuery.of(context).size, s),
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

  Offset _calcPosition(Size screen, Size? size) {
    size = size ?? const Size(0, 0);
    final x = (screen.width / 2 + screen.width / 2 * alignment.x) -
        (size.width * 0.5 + size.width * 0.5 * alignment.x) +
        offset.dx;
    final y = (screen.height / 2 + screen.height / 2 * alignment.y) -
        (size.height * 0.5 + size.height * 0.5 * alignment.y) +
        offset.dy;
    return Offset(x, y);
  }
}
