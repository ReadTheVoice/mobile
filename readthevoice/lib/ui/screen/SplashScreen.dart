import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/ui/color_scheme/color_schemes_material.dart';
import 'package:readthevoice/ui/component/SplashComponents.dart';

import 'MainScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      duration: const Duration(milliseconds: 2000),
      nextScreen: const MainScreen(),
      useImmersiveMode: true,
      splashScreenBody: Container(
        decoration: BoxDecoration(
          // RadialGradial, SweepGradient
          gradient: LinearGradient(
              colors: [lightColorScheme.primary, lightColorScheme.tertiary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: Center(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SplashIcons(svgPath: 'assets/icons/shapes/shape-77.svg', posLeft: 30.0, posBottom: 5.0,), // 77, 64
              const Spacer(),
              SizedBox(
                width: 200,
                child: SvgPicture.asset(
                  "assets/logos/logo_new.svg",
                  placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator(
                          color: Color(0xFFD6E3FF))),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Read The Voice",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: lightColorScheme.primaryContainer,
                ),
              ),
              const Spacer(),
              SplashIcons(svgPath: 'assets/icons/shapes/shape-115.svg', posRight: 30.0, posBottom: 5.0,),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
