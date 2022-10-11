import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overlayment/overlayment.dart';

import 'helpers_test.dart';

void main() {
  const notificationText = 'Notification';
  testWidgets('notification location', (tester) async {
    await addApp(tester);
    for (var alignment in alignmentValues) {
      OverNotification(
        child: const Text(notificationText),
        duration: null,
        alignment: alignment,
      ).show();
      tester.binding.scheduleFrame();
      await tester.pumpAndSettle();
      final widget = find.text(notificationText);
      expect(widget, findsOneWidget);
      final offset = tester.getCenter(widget);
      expect(isInAlignment(offset, alignment, size), true);
      Overlayment.dismissAll();
      await tester.pumpAndSettle();
      expect(widget, findsNothing);
    }
  });

  testWidgets('simple notification', (tester) async {
    await addApp(tester);
    OverNotification.simple(
      title: notificationText,
      message: 'Simple notification',
    ).show();
    tester.binding.scheduleFrame();
    await tester.pumpAndSettle();
    final widget = find.text(notificationText);
    expect(widget, findsOneWidget);
    Overlayment.dismissAll();
    await tester.pumpAndSettle();
    expect(widget, findsNothing);
  });

  testWidgets('simple notification close button', (tester) async {
    await addApp(tester);
    OverNotification.simple(
      title: notificationText,
      message: 'Simple notification',
      icon: const Icon(Icons.mail),
    ).show();
    tester.binding.scheduleFrame();
    await tester.pumpAndSettle();
    final widget = find.text(notificationText);
    expect(widget, findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(widget, findsNothing);
  });

  testWidgets('notification auto dismiss', (tester) async {
    await addApp(tester);
    OverNotification(child: const Text(notificationText)).show();
    tester.binding.scheduleFrame();
    await tester.pumpAndSettle();
    final widget = find.text(notificationText);
    expect(widget, findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(widget, findsNothing);
  });
}
