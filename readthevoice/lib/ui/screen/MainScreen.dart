
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int selectedIndex = 0;

  dynamic selected = 0;
  var heart = false;
  PageController controller = PageController();

  // const Text("AppName").tr(),
  String title = "AppName";

  Text tt = const Text("AppName").tr();
  // Widget tt = const Text("AppName").tr();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
        screen = const HomeScreen();
        break;
      case 1:
        screen = const QrCodeScreen();
        // tt = const Text("AppName").tr();
        tt = const Text("QrCodeScan").tr();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    switch (selected) {
      case 0:
        // screen = const HomeScreen();
        tt = const Text("AppName").tr();
        heart = false;
        break;
      case 1:
        // screen = const QrCodeScreen();
        tt = const Text("QrCodeScan").tr();
        heart = false;
        break;
      case 2:
        // screen = const QrCodeScreen();
        tt = const Text("Meeting");
        // tt = const Text("QrCodeScan").tr();
        heart = false;
        break;
      case 3:
        // screen = const QrCodeScreen();
        tt = const Text("Meeting");
        // tt = const Text("QrCodeScan").tr();
        heart = false;
        break;
      default:
        heart = false;
        throw UnimplementedError('no widget for $selected');
    }

    return Scaffold(
      extendBody: true,
      //to make floating action button notch transparent

      //to avoid the floating action button overlapping behavior,
      // when a soft keyboard is displayed
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: const Text("AppName").tr(),
        title: tt,
        // leading: const FaIcon(FontAwesomeIcons.barsStaggered),  // <i class="fa-solid fa-bars-staggered"></i>
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
      // body: screen,
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(child: HomeScreen()),
            Center(child: QrCodeScreen()),
            Center(child: StreamScreen(meetingId: "meetingId")),
            // Center(child: screen),
            Center(child: Text('Home')),
            // Center(child: Text('Star')),
            // Center(child: Text('Style')),
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
            // badge: const Text('9+'),
            // showBadge: true,
          ),
          BottomBarItem(
            icon: const Icon(Icons.star_border_rounded),
            selectedIcon: const Icon(Icons.star_rounded),
            selectedColor: Colors.red,
            title: const Text('Star'),
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.style_outlined,
              ),
              selectedIcon: const Icon(
                Icons.style,
              ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.deepOrangeAccent,
              title: const Text('Style')),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        currentIndex: selected ?? 0,
        onTap: (index) {
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          controller.jumpToPage(3);
          setState(() {
            heart = true;

            // screen = const QrCodeScreen();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QrCodeScreen(),
              ),
            );
          });
        },
        backgroundColor: Colors.white,
        child: Icon(
          heart ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          color: Colors.red,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
