import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/ui/screen/favorite_meetings_screen.dart';
import 'package:readthevoice/ui/screen/home_screen.dart';
import 'package:readthevoice/ui/screen/qr_code_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  dynamic selected = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
  }

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
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            Center(child: HomeScreen()),
            Center(child: FavoriteMeetingsScreen()),
          ],
        ),
      ),
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
        ),
        items: [
          BottomBarItem(
            icon: Icon(
                selected == 0 ? Icons.house_rounded : Icons.house_outlined),
            unSelectedColor: Colors.grey.shade700,
            selectedColor: Theme.of(context).colorScheme.onSurface,
            title: const Text('home_bottom_bar').tr(),
          ),
          BottomBarItem(
            icon: Icon(selected == 1
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded),
            unSelectedColor: Colors.grey.shade700,
            selectedColor: Theme.of(context).colorScheme.onSurface,
            title: const Text('favorite_bottom_bar').tr(),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        currentIndex: selected ?? 0,
        // enum.index
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
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
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        child: Icon(
          CupertinoIcons.qrcode_viewfinder,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
