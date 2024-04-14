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
import 'package:readthevoice/utils/utils.dart';
import 'package:scrollable_text_indicator/scrollable_text_indicator.dart';
import 'package:toastification/toastification.dart';

class MeetingScreen extends StatefulWidget {
  final Meeting meeting;

  final MeetingModel? meetingModel;

  const MeetingScreen({super.key, required this.meeting, this.meetingModel});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();
  final ScrollController _scrollController = ScrollController();
  final DatabaseReference transcriptDatabaseReference =
      FirebaseDatabase.instance.ref(TRANSCRIPT_COLLECTION);

  late final MeetingST? currentMeeting = null;
  bool hasScroll = false;

  Future<void> initializeAttributes() async {
    var existing = await meetingService.getMeetingById(widget.meetingModel!.id);
    if(existing != null) {
      // currentMeeting = existing;
    } else {
      MeetingST inserting = widget.meetingModel!.toMeetingST();
      // await meetingService.insertMeeting(inserting);

      // currentMeeting = await meetingService.getMeetingById(widget.meetingModel!.id);
    }

    setState(() { });
  }

  Future<void> _getStream() async {
    var transcript =
        await firebaseService.getMeetingTranscription(widget.meetingModel!.id);
    await meetingService.updateMeetingTranscription(
        widget.meetingModel!.id, transcript);
  }

  Future<void> _updateTranscription(
      dynamic data, String? transcriptionId) async {
    await meetingService.updateMeetingTranscription(widget.meetingModel!.id, data);
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
            widget.meetingModel!.name,
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
                              title: const Text('Not yet implemented.'),
                              icon: const FaIcon(
                                  FontAwesomeIcons.triangleExclamation),
                            );

                            Navigator.pop(context);
                            // If they wanna share it
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
                              Text("Show qr code",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      if(widget.meetingModel!.allowDownload)
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () async {
                              await _getStream();

                              if (widget.meetingModel!.transcription != null ? widget.meetingModel!.transcription!.trim().isNotEmpty : false) {
                                bool result = await _permissionRequest();
                                if (result) {
                                  downloadTextFile(widget.meetingModel!.name,
                                      widget.meetingModel!.transcription ?? "",
                                      onSuccess: (filePath) {
                                        toastification.show(
                                          context: context,
                                          alignment: Alignment.bottomCenter,
                                          type: ToastificationType.success,
                                          style: ToastificationStyle.minimal,
                                          autoCloseDuration:
                                          const Duration(seconds: 5),
                                          title: Text("File saved to: $filePath"),
                                          icon:
                                          const Icon(Icons.download_done_rounded),
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
                                  title:
                                  const Text("The transcription is empty."),
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
                      if(widget.meetingModel!.allowDownload)
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () async {
                              // if (widget.meeting.transcription.trim().isNotEmpty) {
                              if (widget.meetingModel!.transcription != null ? widget.meetingModel!.transcription!.trim().isNotEmpty : false) {

                                shareTextFile(widget.meetingModel!.name,
                                    widget.meetingModel!.transcription ?? "");
                              } else {
                                toastification.show(
                                  context: context,
                                  alignment: Alignment.bottomCenter,
                                  type: ToastificationType.error,
                                  style: ToastificationStyle.minimal,
                                  autoCloseDuration: const Duration(seconds: 2),
                                  title:
                                  const Text("The transcription is empty."),
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
              .doc(widget.meetingModel!.id)
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

            if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
              // return const NoDataWidget(currentScreen: AvailableScreens.meeting);
              return const Center(child: Text('Document does not exist'));
            }

            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

            print("data".toUpperCase());
            print(data);

            MeetingModel model = MeetingModel.fromFirebase(snapshot.data!.id, data);
            MeetingStatus status = model.getMeetingStatus();

            return
              Padding(
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
                                const Text("Show details"),
                                const Spacer(),
                                IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.eye,
                                    size: 15,
                                  ),
                                  onPressed: () => {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => DetailsOverlay(
                                          onClose: () => Navigator.pop(context),
                                          meetingModel: widget.meetingModel,
                                          meetingST: currentMeeting ?? MeetingST.example(widget.meetingModel!.id),
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
                      // alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints:
                        BoxConstraints.tightFor(height: screenHeight - 170),
                        child: (widget.meetingModel?.endDate != null ||
                            currentMeeting?.status == MeetingStatus.ended)
                            ? ScrollableTextIndicator(
                          text: Text(widget.meetingModel!.transcription!),
                          indicatorBarColor:
                          Theme.of(context).colorScheme.onBackground,
                          indicatorThumbColor:
                          Theme.of(context).colorScheme.onBackground,
                        )
                            : SingleChildScrollView(
                          controller: _scrollController,
                          child: StreamBuilder(
                              stream: transcriptDatabaseReference
                                  .child(widget.meetingModel!.id)
                                  .onValue,
                              builder: (BuildContext context, snapshot) {
                                print("Snapshot".toUpperCase());
                                print(snapshot);

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator
                                      .adaptive();
                                }

                                if (snapshot.hasData) {
                                  if (snapshot.data != null &&
                                      snapshot.data!.snapshot.exists &&
                                      snapshot.data?.snapshot.value != null) {
                                    // {data: . Bonjour.. . . Un. . deux. . . }
                                    dynamic data =
                                        snapshot.data?.snapshot.value;

                                    // set transcription
                                    _updateTranscription(
                                        data["data"], widget.meetingModel!.id);

                                    if (_scrollController
                                        .positions.isNotEmpty &&
                                        (_scrollController.offset !=
                                            _scrollController
                                                .position.maxScrollExtent)) {
                                      hasScroll = true;
                                    } else {
                                      hasScroll = false;
                                    }

                                    WidgetsBinding.instance
                                        .addPostFrameCallback(_scrollToBottom);

                                    String transcript = data["data"] ?? "";

                                    return Text(
                                        transcript.trim().isNotEmpty ? transcript : "No Transcription");
                                  }

                                  if (snapshot.hasError) {
                                    print("SNAPSHOT ERROR");
                                    print(snapshot.error);
                                  }

                                  return const Center(
                                    child: Text("No Transcription"),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("Error: \n${snapshot.error}");
                                } else {
                                  return (widget.meetingModel!.transcription != null ? widget.meetingModel!.transcription!
                                      .trim()
                                      .isNotEmpty : false)
                                      ? Text(widget.meetingModel!.transcription!)
                                      : const AppPlaceholder();
                                }
                              }),
                        ),
                      ),
                    )
                  ],
                ),
              )
              ;
          },
        )
    );
  }
}

class DetailsOverlay extends StatelessWidget {
  final Function() onClose;

  final MeetingModel? meetingModel;
  final MeetingST meetingST; // pass currentMeeting

  const DetailsOverlay(
      {super.key, required this.onClose, this.meetingModel, required this.meetingST});

  @override
  Widget build(BuildContext context) {
    bool autoDeletion = meetingModel?.deletionDate != null;

    return SafeArea(
        child: Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(children: [
            Center(
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Text(
                            "Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          if (meetingST.archived)
                            const Tooltip(
                              message: "This meeting has been archived!",
                              showDuration: Duration(seconds: 3),
                              child: FaIcon(FontAwesomeIcons.snowflake),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (meetingST.favorite)
                            const Tooltip(
                              message: "This meeting is one of your favorites!",
                              showDuration: Duration(seconds: 3),
                              child: FaIcon(FontAwesomeIcons.solidHeart),
                            )
                        ],
                      ),
                    ),
                  ),
                  MeetingField(name: "meeting_title", value: meetingModel!.name),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MeetingAttributeCard(
                        firstName: "meeting_status",
                        firstValue: meetingST.status.title,
                        secondName: "meeting_schedule_date",
                        secondValue: meetingModel!.scheduledDate!.toString() ?? "",
                      ),
                      MeetingAttributeCard(
                        firstName: "meeting_creator",
                        firstValue: "${meetingModel!.creatorModel?.firstName} ${meetingModel!.creatorModel?.lastName}",
                        // firstValue: meetingST.userName!.trim().isNotEmpty ? meetingST.userName : "${meetingModel!.creatorModel?.firstName} ${meetingModel!.creatorModel?.lastName}",
                        secondName: "meeting_creation_date",
                        secondValue: meetingModel!.createdAt.toString(),
                      ),
                    ],
                  ),
                  MeetingField(
                      name: "meeting_description", value: meetingModel!.description),
                  MeetingField(
                      name: "meeting_end_date",
                      value: meetingModel!.endDate!.toString() ?? ""),
                  if (autoDeletion == true)
                    MeetingField(
                        name: "meeting_auto_delete_date",
                        value: meetingModel!.deletionDate!.toString() ?? ""),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "ID: ${meetingModel!.id}",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: FloatingActionButton(
                mini: true,
                onPressed: onClose,
                backgroundColor: Colors.grey.shade800,
                tooltip: "Close the details view",
                child: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: Colors.white,
                ),
              ),
            )
          ]),
        ),
      ),
    ));
  }
}
