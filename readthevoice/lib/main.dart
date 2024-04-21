import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/firebase_options.dart';
import 'package:readthevoice/ui/helper/connectivity_check_helper.dart';
import 'package:readthevoice/ui/screen/master_screen.dart';
import 'package:readthevoice/ui/screen/no_internet_screen.dart';

import 'ui/color_scheme/color_schemes_material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('it')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // const MyApp({super.key});

  static const String appFontFamily = "Madimi One";

  Map _source = {ConnectivityResult.none: false};
  final ConnectivityCheckHelper _connectivity =
      ConnectivityCheckHelper.instance;

  @override
  void initState() {
    super.initState();
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Widget screen = const MasterScreen();

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        screen = const NoInternetScreen();
      default:
        break;
    }

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        fontFamily: appFontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        fontFamily: appFontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: screen,
    );
  }
}
