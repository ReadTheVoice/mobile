import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/ui/color_scheme/color_schemes_material.dart';
import 'package:readthevoice/ui/component/on_board_page.dart';
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
      finishButtonText: tr('get_started_button'),
      onFinish: () => _onIntroEnd(context),
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: lightColorScheme.surface,
      ),
      skipTextButton: Text(
        'skip_button',
        style: TextStyle(
          fontSize: 16,
          color: titleColor,
          fontWeight: FontWeight.bold,
        ),
      ).tr(),
      trailing: const SizedBox(
        height: 10,
      ),
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
      pageBodies: const [
        OnBoardPage(
          pageTitle: "welcome_title",
          pageText: "welcome_text",
        ),
        OnBoardPage(
          pageTitle: "real_time_title",
          pageText: "real_time_text",
        ),
        OnBoardPage(
          pageTitle: "attending_meetings_title",
          pageText: "attending_meetings_text",
          bottomMargin: 125,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return screenBody();
  }
}
