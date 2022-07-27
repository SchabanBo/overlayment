import 'package:example/screens/section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

import '../../helpers/alignment_extensions.dart';

class NotificationSection extends Section {
  @override
  Widget header(BuildContext context, bool isExpanded) => const ListTile(
        title: Text('Notifications'),
      );

  @override
  final Widget body = const _NotificationSection();
}

class _NotificationSection extends StatefulWidget {
  const _NotificationSection({Key? key}) : super(key: key);

  @override
  _NotificationSectionState createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<_NotificationSection> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        _button(Alignment.topLeft),
        _button(Alignment.centerLeft),
        _button(Alignment.bottomLeft),
        _button(Alignment.topCenter),
        _button(Alignment.center),
        _button(Alignment.bottomCenter),
        _button(Alignment.topRight),
        _button(Alignment.centerRight),
        _button(Alignment.bottomRight),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              for (var item in alignmentValues) {
                _show(item);
              }
            },
            child: const Text(
              'SHOW ALL',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              OverNotification.simple(
                title: 'Simple notification',
                message: 'This is a simple notification',
                icon: const Icon(Icons.info, color: Colors.green),
                withCloseButton: true,
              ).show();
            },
            child: const Text(
              'Simple Notification',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _button(Alignment alignment) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _show(alignment),
        child: Text(
          describeEnum(alignment),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _show(Alignment alignment) {
    Overlayment.show(OverNotification(
      child: child,
      alignment: alignment,
      color: Colors.blue.shade200,
    ));
  }

  Widget get child => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Text('Notification'),
            Text('This this cool notification'),
          ],
        ),
      );
}
