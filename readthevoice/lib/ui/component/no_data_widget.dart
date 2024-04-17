import 'package:flutter/material.dart';
import 'package:readthevoice/utils/utils.dart';

class NoDataWidget extends StatelessWidget {
  final AvailableScreens currentScreen;

  const NoDataWidget({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    Widget widget = const Text("No data");

    switch (currentScreen) {
      case AvailableScreens.home:
        widget = Text("No data for ${currentScreen.name}");
        break;
      default:
        widget = Text("No data for ${currentScreen.name}");
        break;
    }

    return Center(
      child: widget,
    );
  }
}
