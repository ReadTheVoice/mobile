import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardPage extends StatelessWidget {
  final String pageTitle;
  final String pageText;
  final double bottomMargin;
  final String imagePath;
  final double imageWidth;

  const OnBoardPage(
      {super.key,
      required this.pageTitle,
      required this.pageText,
      required this.imagePath,
      this.imageWidth = 250,
      this.bottomMargin = 80});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onBackground;
    final marginTop = MediaQuery.of(context).size.height / 2 + 50;

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imagePath,
            width: imageWidth,
          ),
          Text(
            pageTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
          Padding(
            padding: EdgeInsets.only(bottom: bottomMargin),
            child: Text(
              pageText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 17.0,
              ),
            ).tr(),
          ),
          // Text(
          //   pageText,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: textColor,
          //     fontSize: 17.0,
          //   ),
          //   textScaler: TextScaler.linear(20),
          // ).tr(),
        ],
      ),
    );
  }
}
