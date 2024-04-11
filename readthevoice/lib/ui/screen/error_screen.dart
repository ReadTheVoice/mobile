import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorScreen extends StatefulWidget {
  String text;

  ErrorScreen({super.key, this.text = ""});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    // return const Text("Error Screen");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Error Screen",
                style: TextStyle(color: Colors.white, backgroundColor: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Text(widget.text),
            SvgPicture.asset(
              "assets/images/svg/372-Beauty.svg",
              semanticsLabel: 'My SVG Image',
              height: 200,
              width: 200,
              // allowDrawingOutsideViewBox: true,
            ),
          ],
        ),
      ),
    );
  }
}
