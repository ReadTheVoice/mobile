import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/ui/color_scheme/color_schemes_material.dart';
import 'package:readthevoice/ui/component/PlaceholderComponent.dart';
import 'package:readthevoice/ui/component/SplashComponents.dart';
import 'package:readthevoice/ui/screen/MasterScreen.dart';

class NativeSplashScreen extends StatefulWidget {
  const NativeSplashScreen({super.key});

  @override
  State<NativeSplashScreen> createState() => _NativeSplashScreenState();
}

class _NativeSplashScreenState extends State<NativeSplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MasterScreen()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            // RadialGradial, SweepGradient
            gradient: LinearGradient(
          colors: [lightColorScheme.primary, lightColorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SplashIcons(
                svgPath: 'assets/icons/shapes/shape-77.svg',
                posLeft: 30.0,
                posBottom: 5.0,
              ), // 77, 64
              const Spacer(),
              SizedBox(
                width: 200,
                child: SvgPicture.asset(
                  "assets/logos/logo_new.svg",
                  placeholderBuilder: (BuildContext context) =>
                      PlaceholderComponent(),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                "app_name",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: lightColorScheme.primaryContainer,
                ),
              ).tr(),
              const Spacer(),
              SplashIcons(
                svgPath: 'assets/icons/shapes/shape-115.svg',
                posRight: 30.0,
                posBottom: 5.0,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
