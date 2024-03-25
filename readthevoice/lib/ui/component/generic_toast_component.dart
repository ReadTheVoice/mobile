import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void _showToast(BuildContext context, String title, String? description,
    {bool translateTitle = false, bool translateDescription = false}) {

  var desc = const Text("").tr();
  var translatedDesc = desc.data;

  toastification.show(
    context: context,
    alignment: Alignment.bottomCenter,
    type: ToastificationType.success,
    // style: ToastificationStyle.flat,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 5),
    title: translateTitle ? Text(title).tr() : Text(title),
    // you can also use RichText widget for title and description parameters
    description: description != null ? RichText(text: TextSpan(text: description)) : null,
    icon: const Icon(Icons.check),
    primaryColor: Colors.green,
    // backgroundColor: Colors.white,
    // foregroundColor: Colors.black,
  );
}

