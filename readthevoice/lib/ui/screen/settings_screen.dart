import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/helper/display_toast_helper.dart';
import 'package:readthevoice/ui/screen/master_screen.dart';
import 'package:toastification/toastification.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  MeetingService meetingService = const MeetingService();

  late bool hasMeetings = true;
  late AdaptiveThemeMode savedThemeMode = AdaptiveThemeMode.system;

  Future<void> setupDefaultThemeMode() async {
    savedThemeMode =
        (await AdaptiveTheme.getThemeMode()) ?? AdaptiveThemeMode.system;

    var meetings = await meetingService.getAllMeetings();
    hasMeetings = meetings.isNotEmpty;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setupDefaultThemeMode();
  }

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

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const MasterScreen()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: hasMeetings ? Theme.of(context).colorScheme.surface : Colors.grey,
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
                            fontSize: 15,
                            color:
                            Theme.of(context).colorScheme.onBackground))
                        .tr(),
                    ToggleSwitch(
                      initialLabelIndex: savedThemeMode.isLight
                          ? 0
                          : (savedThemeMode.isDark ? 1 : 2),
                      totalSwitches: 3,
                      icons: [
                        savedThemeMode.isLight
                            ? Icons.brightness_high_rounded
                            : Icons.brightness_low_rounded,
                        savedThemeMode.isDark
                            ? Icons.brightness_4_rounded
                            : Icons.brightness_4_outlined,
                        savedThemeMode.isSystem
                            ? Icons.brightness_auto_rounded
                            : Icons.brightness_auto_outlined
                      ],
                      activeFgColor: Colors.white,
                      inactiveFgColor: Colors.grey.shade200,
                      onToggle: (index) {
                        if (index != null) {
                          switch (index) {
                            case 0:
                              AdaptiveTheme.of(context).setLight();
                              break;
                            case 1:
                              AdaptiveTheme.of(context).setDark();
                              break;
                            case 2:
                            default:
                              AdaptiveTheme.of(context).setSystem();
                              break;
                          }
                        }

                        setupDefaultThemeMode();
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
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onBackground),
                      textAlign: TextAlign.left,
                    ).tr(),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: hasMeetings ? _showConfirmationDialog : null,
                      child: Text(
                        'clear_all_your_data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
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
