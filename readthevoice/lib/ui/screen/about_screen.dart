import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/utils/utils.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          title: const Text("about_screen_title").tr(),
        ),
        body: const NoDataWidget(currentScreen: AvailableScreens.aboutUs));
  }
}
