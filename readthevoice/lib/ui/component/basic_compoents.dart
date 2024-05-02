import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  final Color? color;

  const AppProgressIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(30.0),
          child: CircularProgressIndicator(
              color: color ?? const Color(0xFFD6E3FF))),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text("loading").tr());
  }
}
