import 'package:flutter/material.dart';
import 'package:readthevoice/utils/utils.dart';

class NoDataWidget extends StatelessWidget {
  final AvailableScreens currentScreen;

  const NoDataWidget({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    switch (currentScreen) {
      case AvailableScreens.home:
        return Text("No data for ${currentScreen.name}");
      default:
        return Text("No data for ${currentScreen.name}");
    }
  }
}
