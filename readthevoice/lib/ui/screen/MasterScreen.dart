import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/data/db/rtv_database.dart';
import 'package:readthevoice/ui/component/PlaceholderComponent.dart';
import 'package:readthevoice/ui/screen/AboutScreen.dart';
import 'package:readthevoice/ui/screen/ArchivedMeetingsScreen.dart';
import 'package:readthevoice/ui/screen/MainScreen.dart';
import 'package:readthevoice/ui/screen/QrCodeScreen.dart';
import 'package:readthevoice/ui/screen/SettingsScreen.dart';

class MasterScreen extends StatefulWidget {
  final AppDatabase database;

  const MasterScreen({super.key, required this.database});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int selectedIndex = 0;
  Text screenTitle = const Text("app_name").tr();

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
        screen = MainScreen(database: widget.database,);
        screenTitle = const Text("app_name").tr();
        break;
      case 1:
        screen = QrCodeScreen(true);
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
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 10.0),
              SvgPicture.asset(
                isDarkMode
                    ? "assets/logos/rtv_drawer_black.svg"
                    : "assets/logos/rtv_drawer.svg",
                placeholderBuilder: (BuildContext context) =>
                    PlaceholderComponent(),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                  title: Text(
                    "home_bottom_bar",
                    selectionColor: Theme.of(context).colorScheme.onBackground,
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
                    selectionColor: Theme.of(context).colorScheme.onBackground,
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
                    selectionColor: Theme.of(context).colorScheme.onBackground,
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
                    selectionColor: Theme.of(context).colorScheme.onBackground,
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
                    selectionColor: Theme.of(context).colorScheme.onBackground,
                  ).tr(),
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onTap: () {
                    _onItemTapped(4);
                    Navigator.pop(context);
                  }),
              // const Text("Version 1.0.0")
            ],
          ),
        ),
      ),
      body: screen,
    );
  }
}
