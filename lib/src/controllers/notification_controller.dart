import 'dart:math';

import 'package:flutter/material.dart';

class NotificationController {
  static NotificationController? _instance;
  static NotificationController get instance {
    _instance ??= NotificationController();
    return _instance!;
  }

  final _notifications = <String, Rect>{};

  Offset fixPosition(
      String name, Offset position, Size size, BuildContext context) {
    Rect current() =>
        Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
    final mediaQuery = MediaQuery.of(context);
    final start = max(mediaQuery.viewInsets.top, mediaQuery.viewPadding.top);
    final end = mediaQuery.size.height -
        max(mediaQuery.viewInsets.bottom, mediaQuery.viewPadding.bottom);
    if (position.dy == 0 && start != 0) {
      position = Offset(position.dx, start);
    }
    if (position.dy + size.height == mediaQuery.size.height) {
      position = Offset(position.dx, mediaQuery.size.height - size.height);
    }
    final nots = _notifications.entries.where((kv) => kv.key != name).toList();
    var operation = -1;
    for (var i = 0; i < nots.length; i++) {
      if (nots[i].value.overlaps(current())) {
        var newY = position.dy + (size.height * operation);
        if (newY < start || (newY + size.height) > end) {
          operation = operation * -1;
          newY = position.dy + (size.height * operation);
        }

        position = Offset(position.dx, newY);
      }
    }

    _notifications[name] = current();
    return position;
  }

  void cleanup(String name) {
    _notifications.remove(name);
  }
}
