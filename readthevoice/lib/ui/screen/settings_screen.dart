import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readthevoice/theme/theme.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:readthevoice/theme/theme_provider.dart';

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
        body: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 100,
            ),
            Text("Theme",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground)),
            const SizedBox(width: 100),
            ToggleSwitch(
              initialLabelIndex:
                  Provider.of<ThemeProvider>(context, listen: false)
                              .themeData ==
                          lightMode
                      ? 0
                      : 1,
              totalSwitches: 2,
              icons: const [Icons.sunny, Icons.bedtime],
              activeFgColor: Colors.white,
              inactiveFgColor: Colors.white,
              onToggle: (index) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(index!);
              },
            )
          ],
        ));
  }
}
