import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/firebase_options.dart';
import 'package:readthevoice/theme/theme.dart';
import 'package:readthevoice/ui/helper/connectivity_check_helper.dart';
import 'package:readthevoice/ui/screen/master_screen.dart';
import 'package:readthevoice/ui/screen/no_internet_screen.dart';
import 'package:readthevoice/ui/screen/onboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('it')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, required this.savedThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map _source = {ConnectivityResult.none: false};
  final ConnectivityCheckHelper _connectivity =
      ConnectivityCheckHelper.instance;

  bool onboardingShown = false;

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      onboardingShown = prefs.getBool('onboardingShown') ?? false;
    });
  }

  void _updatePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if(!onboardingShown) {
      await prefs.setBool('onboardingShown', true);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _connectivity.initialize();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = OnboardScreen(onboardingFinished: _updatePreferences);

    if(onboardingShown) {
      screen = const MasterScreen();
    }

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        screen = const NoInternetScreen();
      default:
        break;
    }

    return AdaptiveTheme(
      light: lightMode,
      dark: darkMode,
      initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: "ReadTheVoice",
        theme: theme,
        darkTheme: darkTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: screen,
      ),
    );
  }
}
