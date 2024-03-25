/*
help :
    - https://www.youtube.com/watch?v=yj4aNEOun6I*
    - https://www.youtube.com/watch?v=pKGTKdS8lAs
    - https://pub.dev/packages/qr_code_scanner
*/

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:readthevoice/data/constants.dart';
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

  Future<Meeting?> retrieveMeeting(String meetingId) async {
    Meeting? meeting = await meetingService.getMeetingById(meetingId);
    return meeting;
  }

  // Future<void> _doSomeOperation(String result) async {
  Future<bool> _doSomeOperation(String result) async {
    return result.isNotEmpty && result.contains(QR_CODE_DATA_PREFIX);
    // if (result.isNotEmpty && result.contains(QR_CODE_DATA_PREFIX)) {
    //   await Future.delayed(const Duration(seconds: 1));
    //
    //   // Get the qrCode data and check whether it contains 'readthevoice://' or not
    //   // if yes - proceed with the following
    //   // split and get ID
    //   // get firebase entity
    //   // - created and not started => display dialog stating not yet started & add messenger
    //   // insert if not inserted !
    //   // - created and started but no transcription OR ended => go to meeting_screen
    //   // - ongoing transcription => go to stream_screen
    // } else {
    //   // if no - display dialog saying qr code not recognized / not managed by Read the voice, plus possibility to copy
    //   // if (mounted) {
    //   //   Navigator.pop(context); // Dismiss the dialog after operation
    //   // }
    //
    //   // Navigator.pop(context);
    //
    //   _showNotRecognizedDialog(result, context);
    // }
  }

  void _showNotRecognizedDialog(String qrcodeData, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.qr_code_scanner_rounded),
        title: const Text('Unknown Qr Code'),
        content: Center(
          child: Column(
            children: [
              const Text(
                  'This code has not been generated by **Read The Voice** !'),
              const Text(
                  'However, you can copy the data contained in it and access it using you preferred browser.'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: qrcodeData,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.copy_rounded),
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: qrcodeData));
                              //
                              // Navigator.pop(context);
                            },
                          )),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          // TextButton(
          //   onPressed: () => Navigator.pop(context, false),
          //   child: const Text('Cancel'),
          // ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ok'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed ?? false) {
        // setState(() {
        //   Navigator.pop(context);
        // });
      }
    });
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
                    Text(
                      "Loading...",
                      style: TextStyle(color: Colors.white),
                    ),
                    CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
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
      String result = "";

      setState(() {
        result = scanData.code!;
      });

      if (result.isNotEmpty && result.trim() != "") {
        controller.pauseCamera();

        // Add progress bar
        // Then run with logic
        // If ok, proceed to meetingScreen
        // If not, display error saying "Either the meeting does not exist or has been deleted! Sorry for the inconvenience!"
        // If not yet started, display pop-up saying "Meeting has not yet started! Wait for the host to launch the meeting. Time of meeting: 10:20 AM"
        // Maybe a real dialog

        // _showLoadingDialog();
        bool isOk = await _doSomeOperation(result);
        if (mounted) {
          Navigator.pop(context); // Dismiss the dialog after operation
        }

        if (mounted && !isOk) {
          _showNotRecognizedDialog(result, context);
        }

        if(isOk) {
          // readthevoice://<meeting_id>
          if (result.isNotEmpty) {
            await meetingService.insertMeeting(Meeting(
                result,
                "title fb",
                DateTime
                    .now()
                    .millisecondsSinceEpoch,
                0,
                "transcription fb",
                "userEmail fb",
                "username fb"));
          }

          Meeting? loopy = await meetingService.getMeetingById(result);

          if (mounted) {
            if (isFromDrawer) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StreamScreen(
                          meetingId: result,
                          meeting: loopy,
                        ),
                  ));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StreamScreen(
                          meetingId: result,
                          meeting: loopy,
                        ),
                  ),
                  result: Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MasterScreen())));
            }
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
