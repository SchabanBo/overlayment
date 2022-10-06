import 'package:flutter/material.dart';

import '../../overlayment.dart';

String _defaultQuery(Object o) => o.toString();

/// The widget is used to suggest options to the user based on the input.
/// ```dart
///OverAutoComplete<String>(
///    loadSuggestions: (q) async => store.where((element) => element.contains(q)).take(5).toList(),
///    suggestionsBuilder: (value) => Padding(
///        padding: const EdgeInsets.all(8.0),
///        child: Text(value),
///    ),
///    initialValue: "5",
///    onSelect: (value) => print(value),
///    inputDecoration: const InputDecoration(labelText: 'Enter a number up to 100'),
///),
/// ```
class OverAutoComplete<T extends Object> extends StatefulWidget {
  const OverAutoComplete({
    required this.loadSuggestions,
    required this.onSelect,
    this.querySelector,
    required this.suggestionsBuilder,
    this.inputDecoration,
    this.validator,
    this.overlayHeight = 100,
    this.initialValue,
    Key? key,
    this.loadingWidget = const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator())),
  }) : super(key: key);

  /// Validate if the user can select the given value.
  final bool Function(T)? validator;

  /// a callback to get the value to display in the text field.
  final String Function(T)? querySelector;

  /// The initial value of the text field.
  final T? initialValue;

  /// The TextField input decoration.
  final InputDecoration? inputDecoration;

  /// Load the suggestions for the given query.
  final Future<List<T>> Function(String) loadSuggestions;

  /// The widget to display when the suggestions are loading.
  final Widget loadingWidget;

  /// The height of the suggestions overlay
  final double overlayHeight;

  /// A callback called when the user selects a suggestion.
  final void Function(T) onSelect;

  /// A callback to build the suggestion widget.
  final Widget Function(T) suggestionsBuilder;

  @override
  State<OverAutoComplete<T>> createState() => _OverAutoCompleteState<T>();
}

class _OverAutoCompleteState<T extends Object>
    extends State<OverAutoComplete<T>> {
  T? current;
  bool expanded = false;
  final focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (_isValid(widget.initialValue)) {
      final filter = widget.querySelector ?? _defaultQuery;
      textController.text = filter(widget.initialValue as T);
      current = widget.initialValue;
    }
    focusNode.addListener(() {
      setState(() {
        expanded = focusNode.hasFocus;
      });
    });
    textController.addListener(() {
      if (expanded) return;
      setState(() {
        expanded = true;
      });
    });
  }

  bool _isValid(T? v) =>
      v != null && (widget.validator == null || widget.validator!(v));

  @override
  Widget build(BuildContext context) {
    return OverExpander(
      expand: expanded,
      alignment: Alignment.bottomCenter,
      backgroundSettings: BackgroundSettings.transparent(false),
      expandChild: SizedBox(
        height: widget.overlayHeight,
        child: _Suggestions<T>(
          controller: textController,
          validator: _isValid,
          querySelector: widget.querySelector ?? _defaultQuery,
          loadSuggestions: widget.loadSuggestions,
          suggestionsBuilder: widget.suggestionsBuilder,
          loadingWidget: widget.loadingWidget,
          result: (e) {
            current = e;
            widget.onSelect(e);
            setState(() {
              expanded = false;
            });
          },
        ),
      ),
      isClickable: false,
      child: TextField(
        focusNode: focusNode,
        controller: textController,
        decoration: widget.inputDecoration,
      ),
    );
  }
}

class _Suggestions<T> extends StatefulWidget {
  const _Suggestions({
    required this.controller,
    required this.loadSuggestions,
    required this.validator,
    required this.querySelector,
    required this.result,
    required this.suggestionsBuilder,
    required this.loadingWidget,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final Future<List<T>> Function(String) loadSuggestions;
  final Widget loadingWidget;
  final String Function(T) querySelector;
  final void Function(T) result;
  final Widget Function(T) suggestionsBuilder;
  final bool Function(T) validator;

  @override
  State<_Suggestions> createState() => _SuggestionsState<T>();
}

class _SuggestionsState<T> extends State<_Suggestions<T>> {
  bool isLoading = false;
  late String query = widget.controller.text;
  List<T> suggestions = [];

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
    listen();
  }

  void listen() {
    query = widget.controller.text;
    update(query);
  }

  void update(String v, {bool confirm = false}) {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    widget.loadSuggestions(v).then((value) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        suggestions = value;
      });

      if (confirm && value.isNotEmpty && widget.validator(value.first)) {
        widget.result(value.first);
      }

      if (query != v) {
        update(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return widget.loadingWidget;
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: suggestions
          .map(
            (e) => InkWell(
              child: widget.suggestionsBuilder(e),
              onTap: () {
                query = widget.querySelector(e);
                update(query, confirm: true);
                widget.controller.text = query;
              },
            ),
          )
          .toList(),
    );
  }
}
