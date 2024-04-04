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
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/screen/master_screen.dart';
import 'package:readthevoice/ui/screen/meeting_screen.dart';
import 'package:readthevoice/ui/screen/stream_screen.dart';
import 'package:readthevoice/utils/utils.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;

  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<Meeting?> retrieveMeeting(String meetingId) async {
    Meeting? meeting = await meetingService.getMeetingById(meetingId);
    return meeting;
  }

  void _showNotRecognizedDialog(String qrcodeData) {
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
                  'However, you can copy the data contained in it and access it using your preferred browser.'),
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
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ok'),
          ),
        ],
      ),
    ).then((confirmed) => {
          if (confirmed)
            {
              // Dismiss the dialog after operation
              Navigator.pop(context)
            }
        });
  }

  void _showNotYetStartedDialog(Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.timer_outlined),
        title: Text('${meeting.title} - Not yet started'),
        content: Center(
          child: Column(
            children: [
              Text('The meeting created by: ${meeting.userName}'),
              Text(
                  'The meeting is scheduled for: ${fromMillisToDateTime(meeting.scheduledDateAtMillis!)} !'),
              const Text('Please wait some time for the meeting to start.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ok'),
          ),
        ],
      ),
    ).then((confirmed) => {
          if (confirmed)
            {
              // Dismiss the dialog after operation
              Navigator.pop(context)
            }
        });
  }

  void _showMeetingNotExistingDialog(String meetingId, {String? meetingTitle}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error_outline_rounded),
        title: Text('Meeting ${meetingTitle ?? ""} not found!'),
        content: Center(
          child: Column(
            children: [
              Text(
                  'The meeting with id: $meetingId has not been found!\n It might have been deleted or there might be an error in its id!'),
              const Text(
                  'Please contact the meeting creator for more information.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ok'),
          ),
        ],
      ),
    ).then((confirmed) => {
          if (confirmed)
            {
              // Dismiss the dialog after operation
              Navigator.pop(context)
            }
        });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      String result = "";

      setState(() {
        result = scanData.code!;
      });

      if (result.isNotEmpty && result.trim() != "") {
        controller.pauseCamera();

        bool isOk = result.isNotEmpty && result.contains(QR_CODE_DATA_PREFIX);
        if (mounted) {
          if (!isOk) {
            _showNotRecognizedDialog(result);
          } else {
            // split and get ID
            // readthevoice://<meeting_id>
            String meetingId = result.replaceAll(QR_CODE_DATA_PREFIX, "");

            // get fb entity
            Meeting? meeting = await firebaseService.getMeeting(meetingId);

            // get local entity
            Meeting? existing = await meetingService.getMeetingById(meetingId);

            if (existing != null) {
              // check whether it exists in firestore or not
              if (meeting != null) {
                meeting.transcription = existing.transcription;
                meeting.favorite = existing.favorite;
                meeting.archived = existing.archived;
                meeting.transcriptionId = meeting.transcriptionId ?? existing.transcriptionId;

                if(meeting.endDateAtMillis != null) {
                  meeting.status = MeetingStatus.ended;
                }

                await meetingService.updateMeeting(meeting);
                manageMeeting(meeting);
              } else {
                String title = existing.title;
                await meetingService.deleteMeetingById(existing.id);
                _showMeetingNotExistingDialog(meetingId, meetingTitle: title);
              }
            } else {
              if (meeting != null) {
                // insert it locally
                await meetingService.insertMeeting(meeting);
                manageMeeting(meeting);
              } else {
                _showMeetingNotExistingDialog(meetingId);
              }
            }
          }
        }
      }
    });
  }

  void manageMeeting(Meeting meeting) {
    bool hasNotStarted = meeting.scheduledDateAtMillis != null
        ? fromMillisToDateTime(meeting.scheduledDateAtMillis!)
            .isAfter(DateTime.now())
        : false;
    bool isShowingDialog = false;

    // check whether it started or not
    if (meeting.status == MeetingStatus.createdNotStarted || hasNotStarted) {
      isShowingDialog = true;
      _showNotYetStartedDialog(meeting);
    }

    if (!isShowingDialog) {
      // - created and started but no transcription OR ended => go to meeting_screen
      // - ongoing transcription => go to stream_screen

      // go to meeting screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MeetingScreen(
              meeting: meeting,
            ),
          ),
          result: Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MasterScreen())));
    }
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
      appBar: AppBar(
        title: const Text("qr_code_scan_screen_title").tr(),
      ),
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
