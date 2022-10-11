import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overlayment/overlayment.dart';

void main() {
  test('is in function', () {
    expect(isInAlignment(const Offset(0, 0), Alignment.topLeft, size), true);
    expect(
        isInAlignment(const Offset(200, 0), Alignment.topCenter, size), true);
    expect(isInAlignment(const Offset(300, 0), Alignment.topRight, size), true);

    expect(
        isInAlignment(const Offset(0, 400), Alignment.centerLeft, size), true);
    expect(isInAlignment(const Offset(200, 400), Alignment.center, size), true);
    expect(isInAlignment(const Offset(300, 400), Alignment.centerRight, size),
        true);

    expect(
        isInAlignment(const Offset(0, 600), Alignment.bottomLeft, size), true);
    expect(isInAlignment(const Offset(200, 600), Alignment.bottomCenter, size),
        true);
    expect(isInAlignment(const Offset(300, 600), Alignment.bottomRight, size),
        true);
  });
}

const size = Size(400, 800);

List<Alignment> alignmentValues = [
  Alignment.topLeft,
  Alignment.topCenter,
  Alignment.topRight,
  Alignment.centerLeft,
  Alignment.center,
  Alignment.centerRight,
  Alignment.bottomLeft,
  Alignment.bottomCenter,
  Alignment.bottomRight,
];

Future<void> addApp(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(size);
  tester.binding.window.physicalSizeTestValue = size;
  tester.binding.window.devicePixelRatioTestValue = 1.0;
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  await tester.pumpWidget(const TestApp());
}

bool isInAlignment(Offset offset, Alignment alignment, Size size) {
  final xSpace = size.width / 3;
  final ySpace = size.height / 3;

  return xSpace * (alignment.x + 1) <= offset.dx &&
      xSpace * (alignment.x + 2) >= offset.dx &&
      ySpace * (alignment.y + 1) <= offset.dy &&
      ySpace * (alignment.y + 2) >= offset.dy;
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<NavigatorState>();
    Overlayment.navigationKey = key;
    return MaterialApp(
      navigatorKey: key,
      home: Container(),
    );
  }
}
