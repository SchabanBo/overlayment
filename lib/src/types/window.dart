import 'package:flutter/material.dart';
import 'package:overlayment/src/types/animations/over_animation.dart';
import 'package:overlayment/src/types/overlay_base.dart';

import '../../overlayment.dart';
import '../widgets/filter_widget.dart';
import '../widgets/overlay_widget.dart';
import 'animations/overlay_animation.dart';

/// Show a window at any position on the screen.
/// ```dart
///Overlayment.show(OverWindow(
///   position: Offset(50, 50),
///   canMove: true,
///   child: Text('This is a window'),
///));
/// ```
class OverWindow with OverlayBase {
  OverWindow({
    required this.child,
    this.position,
    this.alignment,
    this.actions = const OverlayActions(),
    this.margin,
    this.color,
    this.backgroundSettings,
    this.animation = const OverFadeAnimation(child: OverScaleAnimation()),
    this.decoration,
    this.canMove = false,
    this.addInsetsPaddings = true,
    this.duration,
    String? name,
    Key? key,
  })  : assert(alignment != null || position != null,
            'Alignment or position must be provided'),
        name = name ?? 'Window${child.hashCode}';

  factory OverWindow.simple({
    required String message,
    TextStyle? messageStyle,
    String? yesMessage,
    String? noMessage,
    bool canCancel = true,
    String? cancelMessage,
    Widget? body,
    bool canMove = false,
    Alignment alignment = Alignment.center,
  }) {
    final name = 'Confirmation${message.hashCode}';
    return OverWindow(
        name: name,
        alignment: alignment,
        backgroundSettings: const BackgroundSettings(),
        canMove: canMove,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(message, style: messageStyle),
            if (body != null) body,
            const Divider(),
            Row(
              children: [
                OutlinedButton(
                  child: Text(yesMessage ?? 'Yes'),
                  onPressed: () => Overlayment.dismissName(name, result: true),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  child: Text(noMessage ?? 'No'),
                  onPressed: () => Overlayment.dismissName(name, result: false),
                ),
                if (canCancel) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    child: Text(cancelMessage ?? 'Cancel'),
                    onPressed: () =>
                        Overlayment.dismissName(name, result: null),
                  ),
                ],
              ],
            ),
          ]),
        ));
  }

  /// The Position where the window should displayed.
  /// If the [position] is provided, the [alignment] is ignored.
  final Alignment? alignment;

  /// {@macro Overlayment.BackgroundSettings}
  final BackgroundSettings? backgroundSettings;

  // Can user drag the window to move it.
  final bool canMove;

  /// The position of the window
  final Offset? position;

  /// {@macro overlay_base.actions}
  @override
  final OverlayActions actions;

  /// {@macro overlay_base.addInsetsPaddings}
  @override
  final bool addInsetsPaddings;

  /// {@macro overlay_base.animation}
  @override
  final OverAnimation animation;

  /// The content of your window
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
          maintainState: false,
          opaque: false,
        ),
      OverlayEntry(
        builder: (context) => OverlayWidget(
          overlay: this,
          height: () => null,
          width: () => null,
          position: (s, m) => _calcPosition(MediaQuery.of(context).size, s, m),
          canMoved: canMove,
        ),
      )
    ];
  }

  @override
  Future<T?> show<T>({BuildContext? context}) =>
      Overlayment.show(this, context: context);

  Offset _calcPosition(Size screen, Size? size, Offset? moveDelta) {
    if (moveDelta != null) return moveDelta;

    if (position != null) {
      if (size == null) return position!;

      var xPercent = position!.dx / screen.width;
      var yPercent = position!.dy / screen.height;
      return Offset(
        position!.dx - size.width * xPercent,
        position!.dy - size.height * yPercent,
      );
    }

    size = size ?? const Size(0, 0);
    final x = (screen.width / 2 + screen.width / 2 * alignment!.x) -
        (size.width * 0.5 + size.width * 0.5 * alignment!.x);
    final y = (screen.height / 2 + screen.height / 2 * alignment!.y) -
        (size.height * 0.5 + size.height * 0.5 * alignment!.y);
    return Offset(x, y);
  }
}
