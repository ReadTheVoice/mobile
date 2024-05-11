import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/theme/theme.dart';
import 'package:readthevoice/theme/theme_provider.dart';
import 'package:readthevoice/ui/helper/display_toast_helper.dart';
import 'package:toastification/toastification.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  MeetingService meetingService = const MeetingService();

  void _showConfirmationDialog() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: (!isDarkMode)
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        title: Text('permanent_deletion_confirmation_title',
                style: TextStyle(
                    color: (!isDarkMode)
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null))
            .tr(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'permanent_confirmation_message_text',
              style: TextStyle(
                  color: (!isDarkMode)
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : null),
            ).tr(),
            Text(
              'permanent_confirmation_message_text_hint',
              style: TextStyle(
                  color: (!isDarkMode)
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : null),
            ).tr(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('cancel', style: TextStyle(fontSize: 20)).tr(),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('confirm', style: TextStyle(fontSize: 20)).tr(),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed ?? false) {
        await meetingService.clearAllData();

        setState(() {
          showToast(
              context,
              "permanent_deletion_confirmation_toast",
              ToastificationType.warning,
              Colors.deepOrangeAccent,
              Icons.front_loader);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text("settings_screen_title").tr(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("theme",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:
                                    Theme.of(context).colorScheme.onBackground))
                        .tr(),
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
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "manage_your_data",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onBackground),
                      textAlign: TextAlign.left,
                    ).tr(),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: _showConfirmationDialog,
                      child: Text(
                        'clear_all_your_data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ).tr(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
