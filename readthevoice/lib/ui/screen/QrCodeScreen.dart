/*
help :
    - https://www.youtube.com/watch?v=yj4aNEOun6I*
    - https://www.youtube.com/watch?v=pKGTKdS8lAs
    - https://pub.dev/packages/qr_code_scanner
*/

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:readthevoice/ui/screen/StreamScreen.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result = "";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;

        // Inside _onQRViewCreated (after the setState call):
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => MyNextPage(qrData: result!.code),
        // ));

        // Navigate to meeting screen
        String meetingId = result;

        if(meetingId.isNotEmpty && meetingId.trim() != "") {
          // if(result.isNotEmpty && result.trim() != "") {
          //   String meetingId = result;
          //   result = "";

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StreamScreen(meetingId: meetingId),
          ));

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => StreamScreen(meetingId: meetingId),
          //     // builder: (context) => DetailScreen(todo: todos[index]),
          //     // builder: (context) => DetailScreen(todo: todos[index]),
          //   ),
          // );
        }
      });
    });
  }

  // Gets the url like: "readthevoice/<meetingId>"
  // Gotta return to the stream screen ! based on the meetingId => pass the meetingId to the screen.
  @override
  void initState() {
    super.initState();

    // widget.addListener(() {
    //   debugPrint("value notifier is true");
    // });

    // result.

    /*
    countdown.reset.notifyListeners();
    // OR
    countdown.reset.value = true;
     */
  }

  @override
  Widget build(BuildContext context) {
    // here
    // if(result.isNotEmpty && result.trim() != "") {
    //   String meetingId = result;
    //   result = "";
    //
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => StreamScreen(meetingId: meetingId),
    //       // builder: (context) => DetailScreen(todo: todos[index]),
    //       // builder: (context) => DetailScreen(todo: todos[index]),
    //     ),
    //   );
    // }

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ),
        Text(
          result,
          style:
              const TextStyle(color: Colors.white, backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
