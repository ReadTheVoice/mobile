import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/utils/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("settings_screen_title").tr(),
        ),
        body: const NoDataWidget(currentScreen: AvailableScreens.settings));
  }
}
