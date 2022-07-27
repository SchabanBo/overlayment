import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

import 'controllers/overlay_controller.dart';
import 'types/overlay_base.dart';

class OverlaymentContext {
  /// a function to log messages from the overlayment library.
  Function(String) log = print;

  /// The app Navigation key. you can set this property so you don't need
  /// to pass a context every time you want to create a new overlay.
  GlobalKey<NavigatorState>? navigationKey;

  final _controller = OverlaysController();

  /// Returns the counts of overlays.
  int get count => _controller.length;

  /// Show an overlay
  Future<T?> show<T>(OverlayBase overlay, {BuildContext? context}) async {
    assert(navigationKey != null || context != null,
        'Either navigationKey or context must be provided');
    final overlayState = context == null
        ? navigationKey!.currentState!.overlay
        : Navigator.of(context).overlay;
    return _controller.add<T?>(overlayState!, overlay);
  }

  /// Dismiss an overlay
  Future<T?> dismiss<T>(OverlayBase overlay, {T? result}) =>
      _controller.dismiss<T>(overlay, result: result);

  /// Dismiss an overlay with [Name]
  Future<T?> dismissName<T>(String name, {T? result}) =>
      _controller.dismissName<T>(name, result: result);

  // Dismiss the last open overlay
  Future<T?> dismissLast<T>({T? result}) =>
      _controller.dismissLast<T>(result: result);

  /// Dismiss all overlays
  Future<void> dismissAll<T>({T? result, bool atSameTime = false}) async {
    return _controller.dismissAll<T>(result: result, atSameTime: atSameTime);
  }

  /// Show a quick Messages in your app.
  /// this method will show the message as bottom panel on small screen
  /// and as notification on big screen.
  void showMessage(
    String message, {
    Icon? icon,
    Duration duration = const Duration(seconds: 3),
    Alignment? alignment,
  }) {
    final child = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon,
          if (icon != null) const SizedBox(width: 8),
          Text(message),
        ],
      ),
    );

    final width = MediaQuery.of(navigationKey!.currentContext!).size.width;
    if (width < 500) {
      show(OverPanel(
        child: child,
        duration: duration,
        backgroundSettings: BackgroundSettings.transparent(false),
        alignment: alignment ?? Alignment.bottomCenter,
      ));
      return;
    }
    show(OverNotification(
      child: child,
      duration: duration,
      alignment: alignment ?? Alignment.bottomRight,
    ));
  }
}
