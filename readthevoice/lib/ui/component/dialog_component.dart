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

/*
AlertDialog(
  icon: const Icon(Icons.warning_amber_rounded),
  title: const Text('confirmation_title').tr(),
  content: const Text('confirmation_message_text').tr(),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context, false),
      child: const Text('cancel').tr(),
    ),
    TextButton(
      onPressed: () => Navigator.pop(context, true),
      child: const Text('confirm').tr(),
    ),
  ],
),
 */

