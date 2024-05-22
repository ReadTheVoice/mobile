import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:readthevoice/ui/screen/master_screen.dart';

class OnBoard {
  final String image, title, description;

  OnBoard(
      {required this.image, required this.title, required this.description});
}

final List<OnBoard> demoData = [
  OnBoard(
    image: "",
    title: "Find Best Musicians All Around Your City",
    description:
        "Thousands of musicians around you are waiting to rock your event.",
  ),
  OnBoard(
    image: "",
    title: "Fastest Way To Book Great Musicians",
    description:
        "Find the perfect match to perform for your event and make the day remarkable.",
  ),
  OnBoard(
    image: "",
    title: "Find Top Sessions Pros For Your Event",
    description:
        "Find the perfect match to perform for your event and make the day remarkable.",
  ),
];

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MasterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      skipStyle: ButtonStyle(
          textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 17)),
          foregroundColor: WidgetStateProperty.all(Colors.redAccent)),
      allowImplicitScrolling: true,
      autoScrollDuration: 300000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "",
          bodyWidget: const Column(
            children: [
              Text('Your Personal Habit Manager',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 248, 64, 64))),
              SizedBox(height: 20),
              Image(image: AssetImage('assets/images/chicken-3070851_640.png')),
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(image: AssetImage('assets/images/chicken-3070851_640.png')),
              SizedBox(height: 20),
              Text('Play Guitar!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 119, 56, 199)))
            ],
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Listen Music!',
                  style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 248, 64, 64))),
              SizedBox(height: 20),
              Image(image: AssetImage('assets/images/chicken-3070851_640.png')),
            ],
          ),
        ),
      ],
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      // onChange: (val) {},
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(
        Icons.arrow_forward,
      ),
      done: const Text('Done',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 248, 64, 64))),
      onDone: () => _onIntroEnd(context),
      nextStyle: ButtonStyle(
          foregroundColor:
              WidgetStateProperty.all(const Color.fromARGB(255, 248, 64, 64))),
      dotsDecorator: const DotsDecorator(
        size: Size.square(10),
        activeColor: Colors.redAccent,
        activeSize: Size.square(17),
      ),
    );
  }
}
