import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomBarNav extends StatefulWidget {
  const BottomBarNav({super.key});

  @override
  State<BottomBarNav> createState() => _BottomBarNavState();
}

class _BottomBarNavState extends State<BottomBarNav> {
  dynamic selected = 0;
  var heart = false;
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StylishBottomBar(
      option: AnimatedBarOptions(
        iconSize: 32,
        barAnimation: BarAnimation.liquid,
        iconStyle: IconStyle.animated,
        opacity: 0.3,
      ),
      items: [
        BottomBarItem(
          icon: const Icon(Icons.abc),
          title: const Text('Abc'),
          backgroundColor: Colors.red,
          selectedIcon: const Icon(Icons.read_more),
        ),
        BottomBarItem(
          icon: const Icon(Icons.safety_divider),
          title: const Text('Safety'),
          backgroundColor: Colors.orange,
        ),
        BottomBarItem(
          icon: const Icon(Icons.cabin),
          title: const Text('Cabin'),
          backgroundColor: Colors.purple,
        ),
      ],
      fabLocation: StylishBarFabLocation.end,
      hasNotch: true,
      currentIndex: selected,
      onTap: (index) {
        setState(() {
          selected = index;
          controller.jumpToPage(index);
        });
      },
    );
  }
}

/*
// Properties

items → List<BottomBarItem>
option → AnimatedBarOptions
option → BubbleBarOptions
backgroundColor → Color
elevation → double
currentIndex → int
iconSize → double
padding → EdgeInsets
inkEffect → bool
inkColor → Color
onTap → Function(int)
opacity → double
borderRadius → BorderRadius
fabLocation → StylishBarFabLocation
hasNotch → bool
barAnimation → BarAnimation
barStyle → BubbleBarStyle
unselectedIconColor → Color
bubbleFillStyle → BubbleFillStyle
iconStyle → IconStyle

items:
option:
backgroundColor:
elevation:
currentIndex:
iconSize:
padding:
inkEffect:
inkColor:
onTap:
opacity:
borderRadius:
fabLocation:
hasNotch:
barAnimation:
barStyle:
unselectedIconColor:
bubbleFillStyle:
iconStyle:
selectedIcon:
 */
