import 'package:example/screens/section.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

class MessageSection extends Section {
  @override
  Widget header(BuildContext context, bool isExpanded) => const ListTile(
        title: Text('Quick Messages'),
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
  final store = List.generate(100, (index) => index.toString());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
              'Quick Messages as panel on small screen and as notification on big screen'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text('Show'),
                onPressed: () {
                  Overlayment.showMessage(
                    'This is a quick message',
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Show with icon'),
                onPressed: () {
                  Overlayment.showMessage(
                    'This is a quick message',
                    icon: const Icon(Icons.warning),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
