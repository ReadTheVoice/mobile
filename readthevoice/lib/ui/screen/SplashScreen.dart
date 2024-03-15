import 'package:animated_gradient/animated_gradient.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/ui/color_scheme/color_schemes_material.dart';

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
      // nextScreen: const MainScreen(),
      useImmersiveMode: true,
      // backgroundColor: lightColorScheme.onPrimaryContainer,
      splashScreenBody: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [lightColorScheme.primary, lightColorScheme.tertiary]
          )
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Positioned(
                // Position the image here
                left: 30.0, // Distance from left edge
                top: 100.0, // Distance from top edge
                child: SvgPicture.asset(
                  "assets/logos/logo_new.svg",
                  placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator(
                          color: Color(0xFFD6E3FF))),
                ),
              ),
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
            ],
          ),
        ),
      ),

    // Center(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         const Spacer(),
    //         SizedBox(
    //           width: 200,
    //           child: SvgPicture.asset(
    //             "assets/logos/logo_new.svg",
    //             placeholderBuilder: (BuildContext context) => Container(
    //                 padding: const EdgeInsets.all(30.0),
    //                 child: const CircularProgressIndicator(
    //                     color: Color(0xFFD6E3FF))),
    //           ),
    //         ),
    //         const SizedBox(height: 10.0),
    //         Text(
    //           "Read The Voice",
    //           style: TextStyle(
    //             fontSize: 25,
    //             fontWeight: FontWeight.bold,
    //             color: lightColorScheme.primaryContainer,
    //           ),
    //         ),
    //         const Spacer(),
    //       ],
    //     ),
    //   ),
    );
  }
}
