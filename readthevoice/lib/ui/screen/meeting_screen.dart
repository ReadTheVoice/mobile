import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/data/service/transcription_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';
import 'package:readthevoice/ui/helper/display_toast_helper.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/ui/screen/meeting_details_screen.dart';
import 'package:scrollable_text_indicator/scrollable_text_indicator.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingModelId;
  final String meetingModelName;
  final bool meetingModelAllowDownload;
  final String meetingModelTranscription;
  final MeetingStatus meetingModelStatus;

  const MeetingScreen(
      {super.key,
      required this.meetingModelId,
      required this.meetingModelName,
      required this.meetingModelAllowDownload,
      required this.meetingModelTranscription,
      required this.meetingModelStatus});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();
  final ScrollController _scrollController = ScrollController();
  final DatabaseReference transcriptDatabaseReference =
      FirebaseDatabase.instance.ref(TRANSCRIPT_COLLECTION);

  late Meeting? currentMeeting = null;
  bool hasScroll = false;

  Future<void> initializeAttributes() async {
    var model = await firebaseService.getMeetingModel(widget.meetingModelId);
    var existing = await meetingService.getMeetingById(widget.meetingModelId);
    if (existing != null) {
      currentMeeting = existing;
    } else {
      Meeting inserting = model!.toMeeting();
      await meetingService.insertMeeting(inserting);

      currentMeeting =
          await meetingService.getMeetingById(widget.meetingModelId);
    }

    setState(() {});
  }

  Future<void> _getStream() async {
    var transcript =
        await firebaseService.getMeetingTranscription(widget.meetingModelId);
    await meetingService.updateMeetingTranscription(
        widget.meetingModelId, transcript);
  }

  Future<void> _updateTranscription(
      dynamic data, String? transcriptionId) async {
    await meetingService.updateMeetingTranscription(
        widget.meetingModelId, data);
  }

  @override
  void initState() {
    super.initState();
    _getStream();
    WidgetsBinding.instance.addPostFrameCallback(_initScrollToBottom);
    hasScroll = false;
    initializeAttributes();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initScrollToBottom(_) {
    if (_scrollController.positions.isNotEmpty) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 20),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToBottom(_) {
    if (!hasScroll) {
      _initScrollToBottom(_);
    }
  }

  static Future<bool> _permissionRequest() async {
    PermissionStatus result;
    result = await Permission.storage.request();

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;

      // On Android 13 (API 33) and above
      if (androidInfo.version.sdkInt >= 33) {
        result = await Permission.manageExternalStorage.request();
      }
    }

    return result.isGranted;
  }

  void _showQrCodeDialog() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: (!isDarkMode)
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            title: Text('show_qr_code_dialog_title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: (!isDarkMode)
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null))
                .tr(),
            content: Padding(
              padding: const EdgeInsets.all(10),
              child: PrettyQrView.data(
                data: '$QR_CODE_DATA_PREFIX${widget.meetingModelId}',
                errorCorrectLevel: QrErrorCorrectLevel.H,
                decoration: PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  image: const PrettyQrDecorationImage(
                    image: AssetImage('assets/logos/logo_new.png'),
                  ),
                ),
              ),
            ),
            actions: [
              FilledButton.icon(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, double.minPositive)),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(10))),
                onPressed: () async {
                  // shareQrCode
                  await shareQrCode(
                      "widget.meetingModelName",
                      '$QR_CODE_DATA_PREFIX${widget.meetingModelId}',
                      Theme.of(context).colorScheme.onPrimaryContainer, () {
                    showUnsuccessfulToast(context, "an_error_occurred",
                        iconData: FontAwesomeIcons.triangleExclamation);
                  });

                  Navigator.pop(context, true);
                },
                icon: Icon(
                  Icons.share_rounded,
                  color: (!isDarkMode)
                      ? Colors.white
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
                label: Text(
                  'share_qr_code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: (!isDarkMode)
                        ? Colors.white
                        : Theme.of(context).colorScheme.primaryContainer,
                  ),
                ).tr(),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.meetingModelName,
            maxLines: 1,
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: widget.meetingModelStatus.backgroundColor,
                ),
                tooltip: tr("meeting_status_app_bar_button"),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        child: Center(
                          child: MeetingStatusChip(
                              meetingStatus: widget.meetingModelStatus),
                        ),
                      ),
                    ]),
            PopupMenuButton(
                iconColor: Theme.of(context).colorScheme.onSurface,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showQrCodeDialog();
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const Text("show_qr_code",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )).tr()
                            ],
                          ),
                        ),
                      ),
                      if (widget.meetingModelAllowDownload)
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () async {
                              await _getStream();

                              if (widget.meetingModelTranscription
                                  .trim()
                                  .isNotEmpty) {
                                bool result = await _permissionRequest();
                                if (result) {
                                  downloadTextFile(widget.meetingModelName,
                                      widget.meetingModelTranscription,
                                      onSuccess: (filePath) {
                                    showSuccessfulToast(context,
                                        "${tr("saved_file_path")}: $filePath",
                                        iconData: Icons.download_done_rounded,
                                        duration: 5);
                                  });
                                }
                              } else {
                                showUnsuccessfulToast(
                                    context, "empty_transcription",
                                    iconData:
                                        FontAwesomeIcons.triangleExclamation,
                                    duration: 2);
                              }

                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Icon(
                                    Icons.file_download_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  "download_transcript",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ).tr()
                              ],
                            ),
                          ),
                        ),
                      if (widget.meetingModelAllowDownload)
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () async {
                              if (widget.meetingModelTranscription
                                  .trim()
                                  .isNotEmpty) {
                                shareTextFile(widget.meetingModelName,
                                    widget.meetingModelTranscription);
                              } else {
                                showUnsuccessfulToast(
                                    context, "empty_transcription",
                                    iconData:
                                        FontAwesomeIcons.triangleExclamation,
                                    duration: 2);
                              }

                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Icon(
                                    Icons.share_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  "share_transcript",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ).tr()
                              ],
                            ),
                          ),
                        ),
                    ]),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseDatabaseService()
              .meetingCollectionReference
              .doc(widget.meetingModelId)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return ErrorScreen(
                text: "${snapshot.error}",
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }

            if (!snapshot.hasData ||
                snapshot.data == null ||
                !snapshot.data!.exists) {
              return Center(child: const Text('unknown_document').tr());
            }

            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            MeetingModel model =
                MeetingModel.fromFirebase(snapshot.data!.id, data);

            Color textColor = Theme.of(context).colorScheme.onBackground;

            return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "show_details",
                          style: TextStyle(color: textColor, fontSize: 20),
                        ).tr(),
                        const Spacer(),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.eye,
                              size: 18, color: textColor),
                          onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MeetingDetailsScreen(
                                      onClose: () => Navigator.pop(context),
                                      meetingModel: model,
                                      meeting: currentMeeting ??
                                          Meeting.example(
                                              widget.meetingModelId),
                                    )))
                          },
                        ),
                      ],
                    ),
                    MeetingCardDivider(color: textColor),
                    MeetingCardDivider(color: textColor),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: (model.endDate != null ||
                              currentMeeting?.status == MeetingStatus.ended)
                          ? ScrollableTextIndicator(
                              text: Text(
                                "${currentMeeting?.transcription}",
                                style: TextStyle(color: textColor, fontSize: 18),
                              ),
                              indicatorBarColor: textColor,
                              indicatorThumbColor: textColor,
                            )
                          : SingleChildScrollView(
                              controller: _scrollController,
                              child: StreamBuilder(
                                  stream: transcriptDatabaseReference
                                      .child(widget.meetingModelId)
                                      .onValue,
                                  builder: (BuildContext context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator
                                          .adaptive();
                                    }

                                    if (snapshot.hasData) {
                                      if (snapshot.data != null &&
                                          snapshot.data!.snapshot.exists &&
                                          snapshot.data?.snapshot.value !=
                                              null) {
                                        dynamic data =
                                            snapshot.data?.snapshot.value;

                                        // set transcription
                                        _updateTranscription(data["data"],
                                            widget.meetingModelId);

                                        if (_scrollController
                                                .positions.isNotEmpty &&
                                            (_scrollController.offset !=
                                                _scrollController.position
                                                    .maxScrollExtent)) {
                                          hasScroll = true;
                                        } else {
                                          hasScroll = false;
                                        }

                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                                _scrollToBottom);

                                        String transcript = data["data"] ?? "";

                                        return Text(
                                          transcript.trim().isNotEmpty
                                              ? transcript
                                              : tr("empty_transcription"),
                                          style: TextStyle(color: textColor, fontSize: 18),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        if (kDebugMode) {
                                          print("SNAPSHOT ERROR");
                                          print(snapshot.error);
                                        }
                                      }

                                      return Center(
                                        child: Text(
                                          "empty_transcription",
                                          style: TextStyle(color: textColor, fontSize: 18),
                                        ).tr(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        "Error: \n${snapshot.error}",
                                        style: TextStyle(color: textColor, fontSize: 18),
                                      );
                                    } else {
                                      return (widget.meetingModelTranscription
                                              .trim()
                                              .isNotEmpty)
                                          ? Text(
                                              widget.meetingModelTranscription,
                                              style:
                                                  TextStyle(color: textColor, fontSize: 18),
                                            )
                                          : const AppProgressIndicator();
                                    }
                                  }),
                            ),
                    )
                  ],
                ));
          },
        ));
  }
}
