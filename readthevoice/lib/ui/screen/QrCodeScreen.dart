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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        // Navigate to meeting screen
        String meetingId = scanData.code!;

        if (meetingId.isNotEmpty && meetingId.trim() != "") {
          controller.pauseCamera();

          // Add progress bar
          // Then run with logic
          // If ok, proceed to meetingScreen
          // If not, display error saying "Either the meeting does not exist or has been deleted! Sorry for the inconvenience!"
          // If not yet started, display pop-up saying "Meeting has not yet started! Wait for the host to launch the meeting. Time of meeting: 10:20 AM"

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamScreen(meetingId: meetingId),
            ),
          );
        }
      });
    });
  }

  // Gets the url like: "readthevoice/<meetingId>"
  // Gotta return to the stream screen ! based on the meetingId => pass the meetingId to the screen.
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller != null) {
        try {
          await controller?.resumeCamera(); // Attempt to resume even if paused
        } catch (error) {
          print("Error resuming camera: $error");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
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
            const Spacer()
          ],
        ),
      ),
    );
  }
}
