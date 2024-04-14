import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:readthevoice/ui/helper/connectivity_check_helper.dart';
import 'package:readthevoice/ui/screen/about_screen.dart';
import 'package:readthevoice/ui/screen/archived_meetings_screen.dart';
import 'package:readthevoice/ui/screen/main_screen.dart';
import 'package:readthevoice/ui/screen/no_internet_screen.dart';
import 'package:readthevoice/ui/screen/settings_screen.dart';
import 'package:readthevoice/utils/utils.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  Text screenTitle = const Text("app_name").tr();

  PackageInfo? packageInfo;

  AvailableScreens selectedScreen = AvailableScreens.main;

  Map _source = {ConnectivityResult.none: false};
  final ConnectivityCheckHelper _connectivity = ConnectivityCheckHelper.instance;

  Future<void> initPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPackage();
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

  void _onItemTapped(AvailableScreens chosenScreen) {
    setState(() {
      selectedScreen = chosenScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    switch (selectedScreen) {
      case AvailableScreens.main:
        screen = const MainScreen();
        screenTitle = const Text("app_name").tr();
        break;
      case AvailableScreens.archivedMeetings:
        screen = const ArchivedMeetingsScreen();
        screenTitle = const Text("archived_meetings_screen_title").tr();
        break;
      case AvailableScreens.settings:
        screen = const SettingsScreen();
        screenTitle = const Text("settings_screen_title").tr();
        break;
      case AvailableScreens.aboutUs:
        screen = const AboutScreen();
        screenTitle = const Text("about_screen_title").tr();
        break;
      default:
        throw UnimplementedError('no widget for $selectedScreen');
    }

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        return const NoInternetScreen();
      default:
        break;
    }

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
                        _onItemTapped(AvailableScreens.main);
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
                        _onItemTapped(AvailableScreens.archivedMeetings);
                        Navigator.pop(context);
                      }),
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
                        _onItemTapped(AvailableScreens.settings);
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
                        _onItemTapped(AvailableScreens.aboutUs);
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
                    )),
              ),
            ],
          ),
        ),
      ),
      body: screen,
    );
  }
}
