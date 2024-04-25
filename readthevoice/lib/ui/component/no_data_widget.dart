import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        text = "no_home_list_title";
        assetPath = "assets/images/svg/QR-code-scanning.svg";
        break;
      case AvailableScreens.favoriteMeetings:
        text = "no_favorite_list_title";
        assetPath = "assets/images/svg/no-fav-data.svg";
        break;
      case AvailableScreens.archivedMeetings:
        text = "no_archived_list_title";
        assetPath = "assets/images/svg/transfer-files.svg";
        width = 300;
        height = 300;
        break;
      default:
        text = "No data for ${currentScreen.name}";
        assetPath = "assets/images/svg/no_data.svg";
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetPath,
              // colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
              width: width,
              height: height,
              fit: BoxFit.contain,
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

class NoMatchingMeeting extends StatelessWidget {
  final String searchText;

  const NoMatchingMeeting({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/images/svg/search.svg",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: const Text("no_match_text")
                .tr(namedArgs: {"searchText": searchText}),
          ),
        ],
      ),
    );
  }
}
