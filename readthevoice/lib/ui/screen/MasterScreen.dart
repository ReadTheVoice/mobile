import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/db/rtv_database.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/ui/component/PlaceholderComponent.dart';
import 'package:readthevoice/ui/screen/AboutScreen.dart';
import 'package:readthevoice/ui/screen/ArchivedMeetingsScreen.dart';
import 'package:readthevoice/ui/screen/MainScreen.dart';
import 'package:readthevoice/ui/screen/QrCodeScreen.dart';
import 'package:readthevoice/ui/screen/SettingsScreen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int selectedIndex = 0;
  Text screenTitle = const Text("app_name").tr();

  AppDatabase? database;

  Future<void> addMeetings(AppDatabase db) async {
    Meeting firstMeeting = Meeting(
        "id 1", "title", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting = Meeting(
        "id 2", "title1", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting2 = Meeting(
        "id 21", "title2", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting3 = Meeting(
        "id 22", "title3", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting4 = Meeting(
        "id 23", "title4", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting5 = Meeting(
        "id 24", "title5", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting6 = Meeting(
        "id 25", "title6", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting7 = Meeting(
        "id 26", "title7", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting8 = Meeting(
        "id 27", "title8", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting9 = Meeting(
        "id 28", "title9", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting10 = Meeting(
        "id 29", "title10", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting11 = Meeting(
        "id 211", "title11", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting12 = Meeting(
        "id 212", "title12", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting13 = Meeting(
        "id 213", "title13", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting14 = Meeting(
        "id 214", "title14", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting15 = Meeting(
        "id 215", "title15", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting16 = Meeting(
        "id 216", "title16", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting17 = Meeting(
        "id 217", "title17", 17, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting18 = Meeting(
        "id 218", "title18", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting19 = Meeting(
        "id 219", "title19", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting20 = Meeting(
        "id 2222", "title20", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting21 = Meeting(
        "id 2111", "title21", 21, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting22 = Meeting(
        "id 2333", "title22", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting23 = Meeting(
        "id 2444", "title23", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting24 = Meeting(
        "id 2555", "title24", 1, 1, "transcription", "userEmail", "username");
    Meeting secondMeeting25 = Meeting(
        "id 2666", "title25", 1, 1, "transcription", "userEmail", "username");

    await db.meetingDao.insertMultipleMeetings([
      firstMeeting,
      secondMeeting,
      secondMeeting2,
      secondMeeting3,
      secondMeeting4,
      secondMeeting5,
      secondMeeting6,
      secondMeeting7,
      secondMeeting8,
      secondMeeting9,
      secondMeeting10,
      secondMeeting11,
      secondMeeting12,
      secondMeeting13,
      secondMeeting14,
      secondMeeting15,
      secondMeeting16,
      secondMeeting17,
      secondMeeting18,
      secondMeeting19,
      secondMeeting20,
      secondMeeting21,
      secondMeeting22,
      secondMeeting23,
      secondMeeting24,
      secondMeeting25
    ]);
  }

  @override
  void initState() {
    super.initState();

    $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build()
        .then((value) async {
      database = value;
      await addMeetings(database!);
      setState(() {});
    });

    // super.initState();
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
        screen = MainScreen(
          database: database,
        );
        screenTitle = const Text("app_name").tr();
        break;
      case 1:
        screen = QrCodeScreen(true);
        screenTitle = const Text("qr_code_scan_screen_title").tr();
        break;
      case 2:
        screen = ArchivedMeetingsScreen(database: database,);
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
