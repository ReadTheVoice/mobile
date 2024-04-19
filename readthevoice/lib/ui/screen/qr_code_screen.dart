import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/screen/meeting_screen.dart';

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
        builder: (BuildContext context) {
          return GiffyDialog.image(
            Image.asset(
              "assets/gifs/question_mark.gif",
              width: 200,
              height: 150,
              fit: BoxFit.contain,
            ),
            title: const Text(
              'unknown_qr_code_title',
              textAlign: TextAlign.center,
            ).tr(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${tr("unknown_qr_code_text")} ${tr("app_name")}!',
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'unknown_qr_code_subtext',
                  textAlign: TextAlign.center,
                ).tr(),
                ListTile(
                  leading: null,
                  title: Text(
                    qrcodeData,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy_rounded),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: qrcodeData));
                    },
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('retry').tr(),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Ok'),
              ),
            ],
          );
        }).then((confirmed) {
      if (confirmed) {
        // Dismiss the dialog after operation
        Navigator.pop(context, true);
      } else {
        controller?.resumeCamera();
      }
    });
  }

  void _showNotYetStartedDialog(MeetingModel meetingModel) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GiffyDialog.image(
            Image.asset(
              "assets/gifs/moving_clock.gif",
              width: 200,
              height: 150,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            title: const Text(
              'scheduled_meeting_title',
              textAlign: TextAlign.center,
            ).tr(namedArgs: {"title": meetingModel.name}),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'scheduled_meeting_text',
                  textAlign: TextAlign.center,
                ).tr(namedArgs: {
                  "date": meetingModel.scheduledDate?.toString() ?? ""
                }),
                const Text(
                  'scheduled_meeting_subtext',
                  textAlign: TextAlign.center,
                ).tr(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'scheduled_meeting_info',
                  textAlign: TextAlign.center,
                ).tr(namedArgs: {
                  "creator":
                      "${meetingModel.creatorModel?.firstName} ${meetingModel.creatorModel?.lastName}"
                }),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Ok'),
              ),
            ],
          );
        }).then((confirmed) => {
          if (confirmed)
            {
              // Dismiss the dialog after operation
              Navigator.pop(context, meetingModel.id)
            }
        });
  }

  void _showMeetingNotExistingDialog(String meetingId, {String? meetingTitle}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GiffyDialog.image(
            Image.asset(
              "assets/gifs/warning_sign.gif",
              // "assets/images/no_data.png",
              width: 200,
              height: 170,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            title: const Text(
              'meeting_not_found_title',
              textAlign: TextAlign.center,
            ).tr(namedArgs: {"title": meetingTitle ?? ""}),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'meeting_not_found_text',
                  textAlign: TextAlign.center,
                ).tr(namedArgs: {"meetingId": meetingId}),
                const Text(
                  'meeting_not_found_subtext',
                  textAlign: TextAlign.center,
                ).tr(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('retry').tr(),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Ok'),
              ),
            ],
          );
        }).then((confirmed) {
      if (confirmed) {
        // Dismiss the dialog after operation
        Navigator.pop(context, true);
      } else {
        controller?.resumeCamera();
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

        bool isOk = result.isNotEmpty && result.startsWith(QR_CODE_DATA_PREFIX);
        if (mounted) {
          if (!isOk) {
            _showNotRecognizedDialog(result);
          } else {
            // split and get ID
            // readthevoice://<meeting_id>
            String meetingId = result.replaceAll(QR_CODE_DATA_PREFIX, "");

            // get fb entity
            MeetingModel? meetingModel =
                await firebaseService.getMeetingModel(meetingId);
            meetingModel?.transcription =
                await firebaseService.getMeetingTranscription(meetingId);

            if (meetingModel != null) {
              meetingModel.creatorModel =
                  await firebaseService.getMeetingCreator(meetingModel.creator);
            }

            Meeting? meeting = meetingModel?.toMeeting();

            // get local entity
            Meeting? existing = await meetingService.getMeetingById(meetingId);

            if (existing != null) {
              // check whether it exists in firestore or not
              if (meeting != null) {
                meeting.favorite = existing.favorite;
                meeting.archived = existing.archived;
                meeting.status = meetingModel!.getMeetingStatus();

                await meetingService.updateMeeting(meeting);
                manageMeeting(meeting, meetingModel);
              } else {
                String title = meetingModel?.name ?? "";
                await meetingService.deleteMeetingById(existing.id);

                _showMeetingNotExistingDialog(meetingId, meetingTitle: title);
              }
            } else {
              if (meeting != null) {
                // insert it locally
                await meetingService.insertMeeting(meeting);
                manageMeeting(meeting, meetingModel!);
              } else {
                _showMeetingNotExistingDialog(meetingId);
              }
            }
          }
        }
      }
    });
  }

  void manageMeeting(Meeting meeting, MeetingModel meetingModel) {
    bool hasNotStarted = meetingModel.scheduledDate != null
        ? meetingModel.scheduledDate!.isAfter(DateTime.now())
        : false;
    bool isShowingDialog = false;

    // check whether it started or not
    var status = meetingModel.getMeetingStatus();
    if (status == MeetingStatus.scheduled || hasNotStarted) {
      isShowingDialog = true;
      _showNotYetStartedDialog(meetingModel);
    }

    if (!isShowingDialog) {
      Navigator.pop(context, meeting.id);
      // go to meeting screen
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeetingScreen(
              meetingModelId: meetingModel.id,
              meetingModelName: meetingModel.name,
              meetingModelAllowDownload: meetingModel.allowDownload,
              meetingModelTranscription: meetingModel.transcription ?? "",
              meetingModelStatus: meetingModel.getMeetingStatus(),
            ),
          ));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller != null) {
        try {
          await controller?.resumeCamera();
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
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),
      ),
    );
  }
}
