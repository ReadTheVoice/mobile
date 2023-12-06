import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text("QrCodeScan").tr(),
    );
  }
}
