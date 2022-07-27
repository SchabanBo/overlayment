import 'package:example/helpers/alignment_extensions.dart';
import 'package:example/screens/section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

class PanelSection extends Section {
  @override
  Widget header(BuildContext context, bool isExpanded) => const ListTile(
        title: Text('Panels'),
      );

  @override
  final Widget body = const _PanelSection();
}

class _PanelSection extends StatefulWidget {
  const _PanelSection({Key? key}) : super(key: key);

  @override
  _PanelSectionState createState() => _PanelSectionState();
}

class _PanelSectionState extends State<_PanelSection> {
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
        _showWithList
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

  Future _show(Alignment alignment) async {
    final result = await Overlayment.show<String>(
        OverPanel(child: child, alignment: alignment));
    if (result != null) {
      await OverNotification(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(result),
        ),
        color: Colors.amber,
      ).show();
    }
  }

  Widget get child => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Panel'),
              const Text('This this cool Panel'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Overlayment.dismissLast(),
                child: const Text('Close'),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText:
                      'Enter you value to return to the previous screen, press Enter to confirm',
                ),
                onSubmitted: (value) => Overlayment.dismissLast(result: value),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Overlayment.dismissAll(),
                child: const Text('Close All'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Overlayment.dismissAll(atSameTime: true),
                child: const Text('Close All at same time'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  Widget get _showWithList => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            Overlayment.show<String>(OverPanel(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text('Cool list'),
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 100,
                            itemBuilder: (c, i) => Text('$i'))),
                    ElevatedButton(
                      onPressed: () => Overlayment.dismissLast(),
                      child: const Text('Close'),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
                alignment: Alignment.centerRight));
          },
          child: const Text(
            'Show long list',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
}
