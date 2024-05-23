import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/ui/screen/master_screen.dart';

class OnboardScreen extends StatefulWidget {
  final Function onboardingFinished;

  const OnboardScreen({super.key, required this.onboardingFinished});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  void _onIntroEnd(context) {
    widget.onboardingFinished();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MasterScreen()),
    );
  }

  Widget screenBody() {
    final Color titleColor = Theme.of(context).colorScheme.onBackground,
        textColor = Theme.of(context).colorScheme.onBackground;
    final Color backgroundColor = Theme.of(context).colorScheme.background;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return OnBoardingSlider(
      finishButtonText: 'Get started',
      onFinish: () => _onIntroEnd(context),
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: titleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Text(""),
      controllerColor: isDarkMode ? textColor : surfaceColor,
      totalPage: 3,
      headerBackgroundColor: backgroundColor,
      pageBackgroundColor: backgroundColor,
      centerBackground: true,
      background: [
        SvgPicture.asset(
          "assets/images/onboarding/QR-code-scanning.svg",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SvgPicture.asset(
            "assets/images/onboarding/undraw_speech_to_text_re_8mtf.svg",
          ),
        ),
        SvgPicture.asset(
          "assets/images/onboarding/Conference-amico.svg",
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'welcome_title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
              const SizedBox(
                height: 20,
              ),
              Text(
                'welcome_text',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'real_time_title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
              const SizedBox(
                height: 20,
              ),
              Text(
                'real_time_text',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'attending_meetings_title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
              const SizedBox(
                height: 20,
              ),
              Text(
                'attending_meetings_text',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return screenBody();
  }
}
