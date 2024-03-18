import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/ui/screen/AboutScreen.dart';
import 'package:readthevoice/ui/screen/ArchivedMeetingsScreen.dart';
import 'package:readthevoice/ui/screen/MainScreen.dart';
import 'package:readthevoice/ui/screen/SettingsScreen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

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
        screen = const MainScreen();
        screenTitle = const Text("app_name").tr();
        break;
      case 1:
        screen = const ArchivedMeetingsScreen();
        screenTitle = const Text("archived_meetings_screen_title").tr();
        break;
      case 2:
        screen = const SettingsScreen();
        screenTitle = const Text("settings_screen_title").tr();
        break;
      case 3:
        screen = const AboutScreen();
        screenTitle = const Text("about_screen_title").tr();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
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
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                  title: const Text("home_bottom_bar").tr(),
                  leading: const Icon(Icons.house_rounded, color: Colors.white,),
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("archived_meetings_screen_title").tr(),
                  leading: const Icon(Icons.archive_outlined, color: Colors.white,),
                  // leading: const Icon(Icons.qr_code_scanner),
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("settings_screen_title").tr(),
                  leading: const Icon(Icons.settings_rounded, color: Colors.white,),
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("about_screen_title").tr(),
                  leading: const Icon(Icons.info_outline, color: Colors.white,),
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
      body: screen,
    );
  }
}
