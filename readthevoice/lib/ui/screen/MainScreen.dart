
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/ui/screen/FavoriteMeetingsScreen.dart';
import 'package:readthevoice/ui/screen/HomeScreen.dart';
import 'package:readthevoice/ui/screen/QrCodeScreen.dart';
import 'package:readthevoice/ui/screen/StreamScreen.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  dynamic selected = 0;
  Text screenTitle = const Text("app_name").tr();
  PageController controller = PageController();


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    controller.jumpToPage(index);
    setState(() {
      selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (selected) {
      case 0:
        screenTitle = const Text("app_name").tr();
        break;
      case 1:
      // FavoriteMeetingsScreen
        screenTitle = const Text("favorite_meetings_screen_title").tr();
        break;
      default:
        throw UnimplementedError('no widget for $selected');
    }

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PageView(
          controller: controller,
          // physics: const NeverScrollableScrollPhysics(),
          children: const [
            Center(child: HomeScreen()),
            Center(child: FavoriteMeetingsScreen()),
          ],
        ),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          // iconSize: 32,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          // opacity: 0.3,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.house_outlined,
            ),
            selectedIcon: const Icon(Icons.house_rounded),
            // selectedColor: Colors.teal,
            unSelectedColor: Colors.blueAccent,
            selectedColor: Colors.yellow,
            backgroundColor: Colors.teal,
            title: const Text('Home'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.star_border_rounded),
            selectedIcon: const Icon(Icons.star_rounded),
            selectedColor: Colors.deepPurple,
            title: const Text('favorite'),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        currentIndex: selected ?? 0,
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        // shape: const CircleBorder(),
        onPressed: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QrCodeScreen(),
              ),
            );
          });
        },
        backgroundColor: Colors.white,
        child: const Icon(
          CupertinoIcons.qrcode_viewfinder,
          color: Colors.red,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

