import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/utils/utils.dart';

class NoDataWidget extends StatelessWidget {
  final AvailableScreens currentScreen;

  const NoDataWidget({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    String text = "";
    String assetPath = "";
    double width = 200;
    double height = 200;

    switch (currentScreen) {
      case AvailableScreens.home:
        text = "You have never scanned any Qr code yet";
        assetPath = "assets/images/no_data.png";
        break;
      case AvailableScreens.favoriteMeetings:
        text = "You do not have any favorite yet";
        // text += "\nClick on the heart next to the description on the card, and you will see it here next time you visit.";
        assetPath = "assets/images/Shopaholics-Avatar.png";
        break;
      default:
        text = "No data for ${currentScreen.name}";
        assetPath = "assets/images/no_data.png";
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
