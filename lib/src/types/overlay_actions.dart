/// the overlay actions to handle the overlay events
class OverlayActions<T> {
  const OverlayActions({
    this.onOpen,
    this.onReady,
    this.canClose,
    this.onClose,
  });

  /// run an action right before an overlay is about to open
  final Future<void> Function()? onOpen;

  /// run an action after the overlay is opened
  final Future<void> Function()? onReady;

  /// run an action when the overlay is about to close
  /// return [False] to cancel the close action
  final Future<bool> Function(T?)? canClose;

  /// run an action when the overlay is closed
  /// you can here change the overlay result and return a new one
  final Future<T?> Function(T?)? onClose;
}
