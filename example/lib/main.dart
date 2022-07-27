import 'package:example/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<NavigatorState>();
    Overlayment.navigationKey = key;
    return MaterialApp(
      navigatorKey: key,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Overlayment'),
        ),
        body: const MainScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: Overlayment.dismissAll,
          child: const Icon(Icons.close),
        ),
      ),
    );
  }
}
