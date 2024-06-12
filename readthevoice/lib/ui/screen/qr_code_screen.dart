import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/dialog_component.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller != null) {
        try {
          await controller?.resumeCamera();
        } catch (error) {
          if (kDebugMode) {
            print("Error resuming camera: $error");
          }
        }
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppDialogComponent(
            imagePath: "assets/gifs/question_mark.gif",
            title: Text('unknown_qr_code_title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: (!isDarkMode)
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null))
                .tr(),
            content: [
              Text('${tr("unknown_qr_code_text")} ${tr("app_name")}!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: (!isDarkMode)
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : null)),
              Text('unknown_qr_code_subtext',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: (!isDarkMode)
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : null))
                  .tr(),
              ListTile(
                leading: null,
                title: Text(qrcodeData,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: (!isDarkMode)
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null)),
                trailing: IconButton(
                  icon: Icon(Icons.copy_rounded,
                      color: (!isDarkMode)
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : null),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: qrcodeData));
                  },
                ),
              )
            ],
            confirmButtonText: "OK",
            cancelButtonText: "retry",
          );
        }).then((confirmed) {
      if (confirmed) {
        Navigator.pop(context, true);
      } else {
        controller?.resumeCamera();
      }
    });
  }

  void _showNotYetStartedDialog(MeetingModel meetingModel) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppDialogComponent(
              imagePath: "assets/gifs/moving_clock.gif",
              title: Text(
                'scheduled_meeting_title',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: (!isDarkMode)
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null),
              ).tr(namedArgs: {"title": meetingModel.name}),
              content: [
                Text(
                  'scheduled_meeting_text',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: (!isDarkMode)
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : null),
                ).tr(namedArgs: {
                  "date": meetingModel.scheduledDate?.toString() ?? ""
                }),
                Text(
                  'scheduled_meeting_subtext',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: (!isDarkMode)
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : null),
                ).tr(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'scheduled_meeting_info',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: (!isDarkMode)
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : null),
                ).tr(namedArgs: {
                  "creator":
                      "${meetingModel.creatorModel?.firstName} ${meetingModel.creatorModel?.lastName}"
                }),
              ],
              confirmButtonText: "OK");
        }).then((confirmed) => {
          if (confirmed) {Navigator.pop(context, meetingModel.id)}
        });
  }

  void _showMeetingNotExistingDialog(String meetingId, {String? meetingTitle}) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppDialogComponent(
            imagePath: "assets/gifs/warning_sign.gif",
            title: Text('meeting_not_found_title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: (!isDarkMode)
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null))
                .tr(namedArgs: {"title": meetingTitle ?? ""}),
            content: [
              Text('meeting_not_found_text',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: (!isDarkMode)
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : null))
                  .tr(namedArgs: {"meetingId": meetingId}),
              Text('meeting_not_found_subtext',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: (!isDarkMode)
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : null))
                  .tr(),
            ],
            confirmButtonText: "OK",
            cancelButtonText: "retry",
          );
        }).then((confirmed) {
      if (confirmed) {
        Navigator.pop(context, true);
      } else {
        controller?.resumeCamera();
      }
    });
  }

  Future<void> checkIOSPermissions(QRViewController controller) async {
    var status = await Permission.camera.request();

    if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isDenied) {
      Navigator.pop(context);
    } else {
      // TODO Test on a real device.... (iOS)
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    if (Platform.isIOS) {
      checkIOSPermissions(controller);
    }

    controller.scannedDataStream.listen((scanData) async {
      String result = "";

      setState(() {
        result = scanData.code!;
      });

      await processQrData(result, qrController: controller);
    });
  }

  Future<void> processQrData(String result,
      {QRViewController? qrController}) async {
    var controller = qrController ?? this.controller;
    if (result.isNotEmpty && result.trim() != "") {
      controller?.pauseCamera();

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

  void _showBadQrCodeSent() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppDialogComponent(
            imagePath: "assets/gifs/moving-xmark.gif",
            title: Text('bad_qr_code_title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: (!isDarkMode)
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null))
                .tr(),
            content: [
              Text('bad_qr_code_text',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: (!isDarkMode)
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : null))
                  .tr(),
            ],
            confirmButtonText: "OK",
          );
        }).then((confirmed) {
      controller?.resumeCamera();
    });
  }

  Future<void> _scanGalleryQrCode() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final mobile_scanner.MobileScannerController controller =
        mobile_scanner.MobileScannerController(
      formats: [
        mobile_scanner.BarcodeFormat.all,
        mobile_scanner.BarcodeFormat.qrCode
      ],
    );

    if (pickedFile != null) {
      final mobile_scanner.BarcodeCapture? barcodes =
          await controller.analyzeImage(
        pickedFile.path,
      );

      if (barcodes != null) {
        if (barcodes.barcodes.isNotEmpty) {
          var result = barcodes.barcodes.first.rawValue;
          await processQrData(result ?? "", qrController: this.controller);
        } else {
          _showBadQrCodeSent();
        }
      } else {
        _showBadQrCodeSent();
      }
    } else {
      // User canceled picking image
      this.controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("qr_code_scan_screen_title").tr(),
      ),
      body: Stack(
        children: [
          Center(
              child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          )),
          Positioned(
              bottom: 50,
              left: 50,
              right: 50,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() async {
                          // TODO Test on real device (iOS)
                          controller?.toggleFlash();
                        });
                      },
                      icon: const Icon(
                        Icons.flashlight_on_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        controller?.pauseCamera();
                        _scanGalleryQrCode();
                      },
                      icon: const Icon(
                        Icons.image_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
