import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class AppDialogComponent extends StatelessWidget {
  const AppDialogComponent(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.content,
      required this.confirmButtonText,
      this.cancelButtonText});

  final String imagePath;
  final Text title;
  final List<Widget> content;
  final String confirmButtonText;
  final String? cancelButtonText;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GiffyDialog.image(
      backgroundColor:
          (!isDarkMode) ? Theme.of(context).colorScheme.primaryContainer : null,
      Image.asset(
        imagePath,
        width: 200,
        height: 170,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
      actions: [
        if (cancelButtonText != null && cancelButtonText!.trim().isNotEmpty)
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelButtonText!, style: const TextStyle(fontSize: 20))
                .tr(),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmButtonText,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
