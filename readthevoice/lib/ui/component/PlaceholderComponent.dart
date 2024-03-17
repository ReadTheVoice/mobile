import 'package:flutter/material.dart';

class PlaceholderComponent extends StatelessWidget {
  Color? color = const Color(0xFFD6E3FF);

  PlaceholderComponent({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30.0),
        child: CircularProgressIndicator(color: color));
  }
}
