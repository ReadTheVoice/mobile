import 'package:flutter/material.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: Theme.of(context).colorScheme.onBackground,
    ));
  }
}

class AppPlaceholder extends StatelessWidget {
  final Color? color;

  const AppPlaceholder({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30.0),
        child:
            CircularProgressIndicator(color: color ?? const Color(0xFFD6E3FF)));
    // color: color ?? Theme.of(context).colorScheme.onBackground));
  }
}
