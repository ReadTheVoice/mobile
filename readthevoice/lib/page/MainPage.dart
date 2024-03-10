import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:readthevoice/page/QrCodePage.dart';
import 'package:readthevoice/page/HomePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const QrCodePage();
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
                  title: const Text("MainPage").tr(),
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
      body: page,
    );
  }
}
