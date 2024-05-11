import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showSuccessfulToast(BuildContext context, String title, {IconData? iconData, int? duration}) {
  toastification.show(
    context: context,
    alignment: Alignment.bottomCenter,
    type: ToastificationType.success,
    style: ToastificationStyle.minimal,
    autoCloseDuration: Duration(seconds: duration ?? 3),
    title: Text(title).tr(),
    icon: Icon(iconData ?? Icons.check_rounded),
    primaryColor: Colors.green,
  );
}

void showUnsuccessfulToast(BuildContext context, String title, {IconData? iconData, int? duration}) {
  toastification.show(
    context: context,
    alignment: Alignment.bottomCenter,
    type: ToastificationType.error,
    style: ToastificationStyle.minimal,
    autoCloseDuration: Duration(seconds: duration ?? 3),
    title: Text(title).tr(),
    icon: Icon(iconData ?? Icons.close_rounded),
    primaryColor: Colors.red,
  );
}

void showToast(BuildContext context, String title, ToastificationType toastType, Color color, IconData iconData, {int? duration}) {
  toastification.show(
    context: context,
    alignment: Alignment.bottomCenter,
    type: toastType,
    style: ToastificationStyle.minimal,
    autoCloseDuration: Duration(seconds: duration ?? 3),
    title: Text(title).tr(),
    icon: Icon(iconData),
    primaryColor: color,
  );
}