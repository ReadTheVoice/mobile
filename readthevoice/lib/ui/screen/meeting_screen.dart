import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/data/service/transcription_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/ui/screen/meeting_details_screen.dart';
import 'package:scrollable_text_indicator/scrollable_text_indicator.dart';
import 'package:toastification/toastification.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingModelId;
  final String meetingModelName;
  final bool meetingModelAllowDownload;
  final String meetingModelTranscription;

  const MeetingScreen(
      {super.key,
      required this.meetingModelId,
      required this.meetingModelName,
      required this.meetingModelAllowDownload,
      required this.meetingModelTranscription});

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

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;

    // On Android 13 (API 33) and above
    if (Platform.isAndroid && androidInfo.version.sdkInt >= 33) {
      result = await Permission.manageExternalStorage.request();
    }

    return result.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.meetingModelName,
            maxLines: 1,
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            toastification.show(
                              context: context,
                              alignment: Alignment.bottomCenter,
                              style: ToastificationStyle.minimal,
                              type: ToastificationType.warning,
                              autoCloseDuration: const Duration(seconds: 2),
                              title: const Text('not_yet_implemented').tr(),
                              icon: const FaIcon(
                                  FontAwesomeIcons.triangleExclamation),
                            );

                            Navigator.pop(context);
                          },
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              Text("show_qr_code",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))
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
                                    toastification.show(
                                      context: context,
                                      alignment: Alignment.bottomCenter,
                                      type: ToastificationType.success,
                                      style: ToastificationStyle.minimal,
                                      autoCloseDuration:
                                          const Duration(seconds: 5),
                                      title: Text(
                                          "${tr("saved_file_path")}: $filePath"),
                                      icon: const Icon(
                                          Icons.download_done_rounded),
                                    );
                                  });
                                }
                              } else {
                                toastification.show(
                                  context: context,
                                  alignment: Alignment.bottomCenter,
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.minimal,
                                  autoCloseDuration: const Duration(seconds: 2),
                                  title: const Text("empty_transcription").tr(),
                                  icon: const FaIcon(
                                      FontAwesomeIcons.triangleExclamation),
                                );
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
                                toastification.show(
                                  context: context,
                                  alignment: Alignment.bottomCenter,
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.minimal,
                                  autoCloseDuration: const Duration(seconds: 2),
                                  title: const Text("empty_transcription").tr(),
                                  icon: const FaIcon(
                                      FontAwesomeIcons.triangleExclamation),
                                );
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
                    ])
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
                text: "Something went wrong\n${snapshot.error}",
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
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

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(height: 70),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text("show_details").tr(),
                              const Spacer(),
                              IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.eye,
                                  size: 15,
                                ),
                                onPressed: () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MeetingDetailsScreen(
                                            onClose: () =>
                                                Navigator.pop(context),
                                            meetingModel: model,
                                            meeting: currentMeeting ??
                                                Meeting.example(
                                                    widget.meetingModelId),
                                          )))
                                },
                              ),
                            ],
                          ),
                          const MeetingCardDivider(),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: screenHeight - 170),
                      child: (model.endDate != null ||
                              currentMeeting?.status == MeetingStatus.ended)
                          ? ScrollableTextIndicator(
                              text: Text("${currentMeeting?.transcription}"),
                              indicatorBarColor:
                                  Theme.of(context).colorScheme.onBackground,
                              indicatorThumbColor:
                                  Theme.of(context).colorScheme.onBackground,
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

                                        return Text(transcript.trim().isNotEmpty
                                            ? transcript
                                            : tr("empty_transcription"));
                                      }

                                      if (snapshot.hasError) {
                                        print("SNAPSHOT ERROR");
                                        print(snapshot.error);
                                      }

                                      return Center(
                                        child: const Text("empty_transcription")
                                            .tr(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Error: \n${snapshot.error}");
                                    } else {
                                      return (widget.meetingModelTranscription
                                              .trim()
                                              .isNotEmpty)
                                          ? Text(
                                              widget.meetingModelTranscription)
                                          : const AppPlaceholder();
                                    }
                                  }),
                            ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}
