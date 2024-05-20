import 'package:flutter/material.dart';
import '../ui/color_scheme/color_schemes_material.dart';

const String appFontFamily = "Madimi One";

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  fontFamily: appFontFamily,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  fontFamily: appFontFamily,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
