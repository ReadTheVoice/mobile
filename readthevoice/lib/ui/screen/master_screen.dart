import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:readthevoice/ui/screen/about_screen.dart';
import 'package:readthevoice/ui/screen/archived_meetings_screen.dart';
import 'package:readthevoice/ui/screen/main_screen.dart';
import 'package:readthevoice/ui/screen/qr_code_screen.dart';
import 'package:readthevoice/ui/screen/settings_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int selectedIndex = 0;
  Text screenTitle = const Text("app_name").tr();

  PackageInfo? packageInfo;

  Future<void> getVersionInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  void initState() {
    super.initState();

    getVersionInfo();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (selectedIndex) {
      case 0:
        screen = const MainScreen();
        screenTitle = const Text("app_name").tr();
        break;
      case 1:
        screen = QrCodeScreen(isFromDrawer: true);
        screenTitle = const Text("qr_code_scan_screen_title").tr();
        break;
      case 2:
        screen = const ArchivedMeetingsScreen();
        screenTitle = const Text("archived_meetings_screen_title").tr();
        break;
      case 3:
        screen = const SettingsScreen();
        screenTitle = const Text("settings_screen_title").tr();
        break;
      case 4:
        screen = const AboutScreen();
        screenTitle = const Text("about_screen_title").tr();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: screenTitle,
        // leading: IconButton(
        //   icon: const FaIcon(FontAwesomeIcons.barsStaggered),
        //   onPressed: () => Scaffold.of(context).openDrawer(),
        // ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 10.0),
                  ListTile(
                      title: Text(
                    "app_name",
                    style: TextStyle(
                        fontSize: 35,
                        color: isDarkMode ? Colors.white : Colors.black),
                  ).tr()),
                  const Divider(
                    height: 10,
                    thickness: 5,
                  ),
                  ListTile(
                      title: Text(
                        "home_bottom_bar",
                        selectionColor:
                            Theme.of(context).colorScheme.onBackground,
                      ).tr(),
                      leading: Icon(
                        Icons.house_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onTap: () {
                        _onItemTapped(0);
                        Navigator.pop(context);
                      }),
                  ListTile(
                      title: Text(
                        "qr_code_scan_screen_title",
                        selectionColor:
                            Theme.of(context).colorScheme.onBackground,
                      ).tr(),
                      leading: Icon(
                        Icons.qr_code_scanner,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onTap: () {
                        _onItemTapped(1);
                        Navigator.pop(context);
                      }),
                  ListTile(
                      title: Text(
                        "archived_meetings_screen_title",
                        selectionColor:
                            Theme.of(context).colorScheme.onBackground,
                      ).tr(),
                      leading: Icon(
                        Icons.archive_outlined,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onTap: () {
                        _onItemTapped(2);
                        Navigator.pop(context);
                      }),
                  // ListTile(
                  //     title: Text(
                  //       "Light/Dark Theme",
                  //       selectionColor: Theme.of(context).colorScheme.onBackground,
                  //     ).tr(),
                  //     leading: Icon(
                  //       Icons.nights_stay_outlined,
                  //       color: Theme.of(context).colorScheme.onBackground,
                  //     ),
                  //     subtitle: const Text("Not yet implemented"),
                  //     onTap: () {},
                  //     enabled: false),
                  ListTile(
                      title: Text(
                        "settings_screen_title",
                        selectionColor:
                            Theme.of(context).colorScheme.onBackground,
                      ).tr(),
                      leading: Icon(
                        Icons.settings_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onTap: () {
                        _onItemTapped(3);
                        Navigator.pop(context);
                      }),
                  ListTile(
                      title: Text(
                        "about_screen_title",
                        selectionColor:
                            Theme.of(context).colorScheme.onBackground,
                      ).tr(),
                      leading: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onTap: () {
                        _onItemTapped(4);
                        Navigator.pop(context);
                      }),
                ],
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  padding: const EdgeInsets.all(8.0), // Add some padding
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Version ${packageInfo?.version}",
                        ),
                        Text(
                          "Build number: ${packageInfo?.buildNumber}",
                        ),
                      ],
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
      body: screen,
    );
  }
}