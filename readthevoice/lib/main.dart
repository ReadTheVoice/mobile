import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/firebase_options.dart';
import 'package:readthevoice/ui/screen/splash_screen.dart';

import 'ui/color_scheme/color_schemes_material.dart';

// void main() async {
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    EasyLocalization(
      // supportedLocales: const [Locale('en', 'US'), Locale('fr'), Locale('it')],
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('it')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String appFontFamily = "Madimi One";

  @override
  Widget build(BuildContext context) {
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
      home: const NativeSplashScreen(),
    );
  }
}
