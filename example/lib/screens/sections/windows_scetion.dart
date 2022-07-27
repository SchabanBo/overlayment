import 'dart:math';

import 'package:example/screens/section.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

class WindowSection extends Section {
  @override
  Widget header(BuildContext context, bool isExpanded) => const ListTile(
        title: Text('Windows'),
      );

  @override
  final Widget body = const _WindowSection();
}

class _WindowSection extends StatefulWidget {
  const _WindowSection({Key? key}) : super(key: key);

  @override
  _WindowSectionState createState() => _WindowSectionState();
}

class _WindowSectionState extends State<_WindowSection> {
  double _offsetX = 0;
  double _offsetY = 0;
  int _seconds = 0;
  bool _isFLoating = true;
  bool _canMoved = false;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          children: [
            const Text(' X  '),
            Text(_offsetX.toStringAsFixed(2)),
            Expanded(
              child: Slider(
                  min: 0,
                  max: MediaQuery.of(context).size.width,
                  value: _offsetX,
                  label: 'offset X',
                  onChanged: (v) => setState(() {
                        _offsetX = v;
                      })),
            ),
          ],
        ),
        Row(
          children: [
            const Text(' Y  '),
            Text(_offsetY.toStringAsFixed(2)),
            Expanded(
              child: Slider(
                  min: 0,
                  max: MediaQuery.of(context).size.height,
                  value: _offsetY,
                  label: 'offset Y',
                  onChanged: (v) => setState(() {
                        _offsetY = v;
                      })),
            ),
          ],
        ),
        Row(
          children: [
            const Text(' Show for (Seconds)'),
            Text(_seconds.toString()),
            Expanded(
              child: Slider(
                  min: 0,
                  max: 5,
                  value: _seconds.toDouble(),
                  onChanged: (v) => setState(() {
                        _seconds = v.toInt();
                      })),
            ),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                const Text(' Is Floating  '),
                Text(_isFLoating.toString()),
                Checkbox(
                    value: _isFLoating,
                    onChanged: (s) => setState(() {
                          _isFLoating = s!;
                        })),
              ],
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                const Text(' Can be moved  '),
                Text(_isFLoating.toString()),
                Checkbox(
                    value: _canMoved,
                    onChanged: (s) => setState(() {
                          _canMoved = s!;
                        })),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: show,
            child: const Text(
              'Show',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _offsetX =
                  Random().nextDouble() * MediaQuery.of(context).size.width;
              _offsetY =
                  Random().nextDouble() * MediaQuery.of(context).size.height;
              setState(() {});
              show();
            },
            child: const Text(
              'Show at random position',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              final result = await OverWindow.simple(message: 'Are you sure?')
                  .show<bool?>();
              OverNotification(
                  child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('Result: $result'),
              )).show();
            },
            child: const Text(
              'Show confirmation window',
              style: TextStyle(fontSize: 18),
            ),
          ),
        )
      ],
    );
  }

  void show() {
    final name = Random().nextInt(1000).toString();
    Overlayment.show(OverWindow(
      name: name,
      position: Offset(_offsetX, _offsetY),
      backgroundSettings: _isFLoating ? null : const BackgroundSettings(),
      canMove: _canMoved,
      duration: _seconds <= 0 ? null : Duration(seconds: _seconds),
      child: child(name),
    ));
  }

  Widget child(String name) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text('Window $name'),
            const Text('This this cool Window'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Overlayment.dismissName(name),
              child: const Text('Dismiss'),
            )
          ],
        ),
      );
}
