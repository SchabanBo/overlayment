import 'package:example/screens/section.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

class GlobalExpandersSection extends Section {
  @override
  Widget header(BuildContext context, bool isExpanded) => const ListTile(
        title: Text('Global Expanders'),
      );

  @override
  final Widget body = const _GlobalExpandersSection();
}

class _GlobalExpandersSection extends StatefulWidget {
  const _GlobalExpandersSection({Key? key}) : super(key: key);

  @override
  _GlobalExpandersSectionState createState() => _GlobalExpandersSectionState();
}

class _GlobalExpandersSectionState extends State<_GlobalExpandersSection> {
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
      ],
    );
  }

  Widget _button(Alignment alignment) {
    return OverExpander(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          alignment.toString(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      globalAlignment: alignment,
      expandChild: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              alignment.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            child
          ],
        ),
      ),
    );
  }

  Widget get child => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Text('GlobalExpanders'),
            Text('This this cool GlobalExpanders'),
          ],
        ),
      );
}
