import 'package:flutter/material.dart';

class DialogComponent extends StatelessWidget {
  final String title;
  final String content;
  String? cancelText;
  String? confirmText;

  final Function confirmFunction;

  DialogComponent({super.key, required this.title, required this.content, this.cancelText, this.confirmText, required this.confirmFunction});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
