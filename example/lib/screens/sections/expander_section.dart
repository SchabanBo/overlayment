import 'package:example/screens/section.dart';
import 'package:flutter/material.dart';
import 'package:overlayment/overlayment.dart';

class ExpanderSection extends Section {
  @override
  Widget header(BuildContext context, bool isExpanded) => const ListTile(
        title: Text('Expanders'),
      );

  @override
  final Widget body = const _ExpanderSection();
}

class _ExpanderSection extends StatefulWidget {
  const _ExpanderSection({Key? key}) : super(key: key);

  @override
  _ExpanderSectionState createState() => _ExpanderSectionState();
}

class _ExpanderSectionState extends State<_ExpanderSection> {
  var _index = 0;
  final _name = 'ExpanderSectionIndex';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OverExpander<int>(
            name: _name,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected Index: $_index',
                style: const TextStyle(
                    fontSize: 18, decoration: TextDecoration.underline),
              ),
            ),
            onSelect: (i) {
              if (i != null) {
                setState(() {
                  _index = i;
                });
              }
            },
            height: 300,
            expandChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: List.generate(
                  10,
                  (index) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Overlayment.dismissName<int>(_name, result: index);
                      },
                      child: Text(index.toString()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
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
      alignment: alignment,
      expandChild: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(alignment.toString()),
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
            Text('Expanders'),
            Text('This this cool Expander'),
          ],
        ),
      );
}
