import 'package:flutter/material.dart';

abstract class Section {
  bool isExpanded = false;

  Widget header(BuildContext context, bool isExpanded);

  Widget get body;
}
