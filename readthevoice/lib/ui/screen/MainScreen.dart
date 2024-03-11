import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:readthevoice/ui/screen/QrCodeScreen.dart';
import 'package:readthevoice/ui/screen/HomeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

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
        screen = const HomeScreen();
        break;
      case 1:
        screen = const QrCodeScreen();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("AppName").tr(),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                  title: const Text("HomeScreen").tr(),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    _onItemTapped(0);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("QrCodeScan").tr(),
                  leading: const Icon(Icons.qr_code_scanner),
                  onTap: () {
                    _onItemTapped(1);
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
