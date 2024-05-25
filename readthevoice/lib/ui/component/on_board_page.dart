import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnBoardPage extends StatelessWidget {
  final String pageTitle;
  final String pageText;
  final double bottomMargin;

  const OnBoardPage(
      {super.key,
      required this.pageTitle,
      required this.pageText,
      this.bottomMargin = 80});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onBackground;
    final marginTop = MediaQuery.of(context).size.height / 2 + 50;

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Positioned(
          //     bottom: bottomMargin,
          //     child: SvgPicture.asset(
          //       "assets/icons/shapes/shape-68.svg",
          //       colorFilter: ColorFilter.mode(
          //           lightColorScheme.surface.withOpacity(0.7),
          //           BlendMode.srcIn),
          //     )),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: marginTop,
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  pageText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17.0,
                  ),
                ).tr(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
