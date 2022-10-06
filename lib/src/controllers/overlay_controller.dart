import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';
import 'package:overlayment/src/controllers/notification_controller.dart';

import '../types/overlay_base.dart';

class OverlaysController {
  final _requests = <_OverlayRequest>[];

  int get length => _requests.length;

  Future<T?> add<T>(OverlayState overlayState, OverlayBase overlay) async {
    final request = _OverlayRequest<T>(overlay);
    _requests.add(request);
    overlayState.insertAll(request.overlayEntries());
    if (overlay.duration != null) {
      request.timer = Timer(overlay.duration!, () {
        _dismiss(request);
      });
    }
    return request.completer.future;
  }

  Future<T?> _dismiss<T>(_OverlayRequest request, {T? result}) async {
    if (await request.cleanup(result: result)) {
      if (_requests.contains(request)) _requests.remove(request);
    }

    return (await request.completer.future) as T?;
  }

  Future<T?> dismiss<T>(OverlayBase overlay, {T? result}) =>
      _findAndDismiss((element) => element.overlay == overlay, result: result);

  Future<T?> dismissName<T>(String name, {T? result}) =>
      _findAndDismiss((element) => element.overlay.name == name,
          result: result);

  Future<T?> dismissLast<T>({T? result}) =>
      _dismiss<T>(_requests.last, result: result);

  Future<void> dismissAll<T>({T? result, bool atSameTime = false}) async {
    for (var item in _requests.reversed.toList()) {
      if (atSameTime) {
        _dismiss(item, result: result);
      } else {
        await _dismiss(item, result: result);
      }
    }
  }

  Future<T?> _findAndDismiss<T>(
    bool Function(_OverlayRequest<dynamic>) query, {
    T? result,
  }) {
    if (_requests.any(query)) {
      return _dismiss(_requests.firstWhere(query), result: result);
    }
    return Future.value(null);
  }
}

class _OverlayRequest<T> {
  final OverlayBase overlay;
  final completer = Completer<T?>();
  bool mounted = true;
  Timer? timer;
  _OverlayRequest(this.overlay);

  final _overlayEntries = <OverlayEntry>[];

  List<OverlayEntry> overlayEntries() {
    _overlayEntries.clear();
    _overlayEntries.addAll(overlay.buildEntries());
    return _overlayEntries;
  }

  Future<bool> cleanup({T? result}) async {
    if (!mounted) {
      if (!completer.isCompleted) completer.complete(result);
      return true;
    }
    mounted = false;
    timer?.cancel();
    timer = null;
    if (overlay.actions.canClose != null) {
      final canClose = await overlay.actions.canClose!(result);
      if (!canClose) {
        return false;
      }
    }
    await overlay.overlayAnimation.reverse();
    if (overlay is OverNotification) {
      NotificationController.instance.cleanup(overlay.name);
    }
    if (overlay.actions.onClose != null) {
      result = await overlay.actions.onClose!(result);
    }

    for (var item in _overlayEntries) {
      item.remove();
    }
    _overlayEntries.clear();
    overlay.overlayAnimation.dispose();
    if (!completer.isCompleted) completer.complete(result);
    return true;
  }
}
