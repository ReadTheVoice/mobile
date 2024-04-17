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

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  PackageInfo? packageInfo;

  Map _source = {ConnectivityResult.none: false};
  final ConnectivityCheckHelper _connectivity =
      ConnectivityCheckHelper.instance;

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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        return const NoInternetScreen();
      default:
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("app_name").tr(),
        // title: screenTitle,
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
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ArchivedMeetingsScreen()));
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
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SettingsScreen()));
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
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AboutScreen()));
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
      body: const MainScreen(),
    );
  }
}
