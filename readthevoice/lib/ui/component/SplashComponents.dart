import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/ui/component/PlaceholderComponent.dart';

class SplashIcons extends StatelessWidget {
  final String svgPath;
  double? posLeft;
  double? posRight;
  double? posTop;
  double? posBottom;

  SplashIcons({
    super.key,
    required this.svgPath,
    this.posLeft,
    this.posRight,
    this.posTop,
    this.posBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background element for Stack
        Container(
          height: 110.0,
          color: Colors.transparent,
          // color: Colors.grey[200],
        ),
        Positioned(
          // Position the image here
          left: posLeft,
          top: posTop,
          right: posRight,
          bottom: posBottom,
          child: SvgPicture.asset(
            svgPath,
            height: 100,
            width: 100,
            placeholderBuilder: (BuildContext context) =>
                PlaceholderComponent(),
          ),
        ),
      ],
    );
  }
}
