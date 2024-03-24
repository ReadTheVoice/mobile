/*
help :
    - https://www.youtube.com/watch?v=yj4aNEOun6I*
    - https://www.youtube.com/watch?v=pKGTKdS8lAs
    - https://pub.dev/packages/qr_code_scanner
*/

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/screen/master_screen.dart';
import 'package:readthevoice/ui/screen/stream_screen.dart';

class QrCodeScreen extends StatefulWidget {
  bool? isFromDrawer = false;

  QrCodeScreen({super.key, this.isFromDrawer});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;

  bool _isLoading = false;

  MeetingService meetingService = const MeetingService();

  bool isFromDrawer = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _doSomeOperation() async {
    // Simulate some background operation (replace with your actual logic)
    await Future.delayed(const Duration(seconds: 10));
  }

  Future<Meeting?> retrieveMeeting(String meetingId) async {
    Meeting? loopy = await meetingService.getMeetingById(meetingId);
    return loopy;
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from tapping outside to dismiss
      builder: (context) => const PopScope(
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

  // void _onQRViewCreated(QRViewController controller, BuildContext context) {
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      String meetingId = "";

      setState(() {
        meetingId = scanData.code!;
      });

      if (meetingId.isNotEmpty && meetingId.trim() != "") {
        controller.pauseCamera();

        // Add progress bar
        // Then run with logic
        // If ok, proceed to meetingScreen
        // If not, display error saying "Either the meeting does not exist or has been deleted! Sorry for the inconvenience!"
        // If not yet started, display pop-up saying "Meeting has not yet started! Wait for the host to launch the meeting. Time of meeting: 10:20 AM"
        // Maybe a real dialog

        _showLoadingDialog();
        await _doSomeOperation();
        if (mounted) {
          Navigator.pop(context); // Dismiss the dialog after operation
        }

        // readthevoice://<meeting_id>
        if (meetingId.isNotEmpty) {
          await meetingService.insertMeeting(Meeting(
              meetingId,
              "title fb",
              DateTime.now().millisecondsSinceEpoch,
              0,
              "transcription fb",
              "userEmail fb",
              "username fb"));
        }

        Meeting? loopy = await meetingService.getMeetingById(meetingId);

        if (mounted) {
          if (isFromDrawer) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StreamScreen(
                    meetingId: meetingId,
                    meeting: loopy,
                  ),
                ));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StreamScreen(
                    meetingId: meetingId,
                    meeting: loopy,
                  ),
                ),
                result: Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MasterScreen())));
          }
        }

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ErrorScreen(),
        //   ),
        // );
      }
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
    if (widget.isFromDrawer != null) {
      isFromDrawer = widget.isFromDrawer!;
    }

    return Scaffold(
      appBar: !isFromDrawer
          ? AppBar(
              title: const Text("qr_code_scan_screen_title").tr(),
            )
          : null,
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
