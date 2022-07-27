import 'package:example/screens/section.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

class DialogSection extends Section {
  @override
  Widget header(BuildContext context, bool isExpanded) => const ListTile(
        title: Text('Dialog'),
      );

  @override
  final Widget body = const _DialogSection();
}

class _DialogSection extends StatefulWidget {
  const _DialogSection({Key? key}) : super(key: key);

  @override
  _DialogSectionState createState() => _DialogSectionState();
}

class _DialogSectionState extends State<_DialogSection> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => _show(),
            child: const Text(
              'Show Dialog',
              style: TextStyle(fontSize: 18),
            ),
          ),
        )
      ],
    );
  }

  void _show() {
    Overlayment.show(
      OverDialog(
        child: child,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget get child => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Dialog'),
            Text('This this cool dialog'),
          ],
        ),
      );
}
