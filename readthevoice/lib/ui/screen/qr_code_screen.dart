/*
help :
    - https://www.youtube.com/watch?v=yj4aNEOun6I*
    - https://www.youtube.com/watch?v=pKGTKdS8lAs
    - https://pub.dev/packages/qr_code_scanner
*/

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/screen/stream_screen.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';

class QrCodeScreen extends StatefulWidget {
  bool isFromDrawer;

  // QrCodeScreen(super.key, [this.isFromDrawer = false]);
  QrCodeScreen([this.isFromDrawer = false]) {super.key;}

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;

  bool _isLoading = false;

  MeetingService meetingService = const MeetingService();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _doSomeOperation() async {
    // Simulate some background operation (replace with your actual logic)
    await Future.delayed(const Duration(seconds: 10));
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from tapping outside to dismiss
      // builder: (context) => WillPopScope(
      builder: (context) => const PopScope(
        // onWillPop: () => Future.value(false), // Prevent dismissal during operation
        // onPopInvoked: () => Future.value(false), // Prevent dismissal during operation
        canPop: false, // Prevent dismissal during operation
        child: Center(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Text("Loading..."),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        // Navigate to meeting screen
        String meetingId = scanData.code!;

        if (meetingId.isNotEmpty && meetingId.trim() != "") {
          controller.pauseCamera();

          // Add progress bar
          // Then run with logic
          // If ok, proceed to meetingScreen
          // If not, display error saying "Either the meeting does not exist or has been deleted! Sorry for the inconvenience!"
          // If not yet started, display pop-up saying "Meeting has not yet started! Wait for the host to launch the meeting. Time of meeting: 10:20 AM"

          _showLoadingDialog();
          await _doSomeOperation();
          Navigator.pop(context); // Dismiss the dialog after operation

          // readthevoice://<meeting_id>
          if(meetingId.isNotEmpty) {
            await meetingService.insertMeeting(Meeting(meetingId, "title fb $meetingId", DateTime.now().millisecondsSinceEpoch, 0, "transcription fb", "userEmail fb", "username fb"));
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamScreen(meetingId: meetingId),
            ),
          );

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const ErrorScreen(),
          //   ),
          // );
        }
      });
    });
  }

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
      appBar: !widget.isFromDrawer ? AppBar(
        title: const Text("Qr code scan"),
      ) : null,
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
