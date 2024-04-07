import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/data/service/transcription_service.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';
import 'package:readthevoice/utils/utils.dart';
import 'package:toastification/toastification.dart';

class MeetingScreen extends StatefulWidget {
  final Meeting meeting;

  const MeetingScreen({super.key, required this.meeting});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();
  Stream<DatabaseEvent>? stream;
  OverlayEntry? detailsOverlayEntry; // Variable to hold the OverlayEntry
  final ScrollController _scrollController = ScrollController();

  Future<void> _getStream() async {
    stream =
        await firebaseService.streamMeetingTranscription(widget.meeting.id);
  }

  Future<void> _updateTranscription(
      dynamic data, String? transcriptionId) async {
    await meetingService.updateMeetingTranscription(widget.meeting.id, data);
  }

  @override
  void initState() {
    super.initState();
    _getStream();
    WidgetsBinding.instance.addPostFrameCallback(_scrollToBottom);
  }

  void _scrollToBottom(_) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void removeDetailsOverlay(BuildContext context) {
    detailsOverlayEntry?.remove();
    detailsOverlayEntry = null;
  }

  void _showDetailsOverlay(BuildContext context) {
    detailsOverlayEntry = OverlayEntry(
      builder: (context) => DetailsOverlay(
        onClose: () => removeDetailsOverlay(context),
        meeting: widget.meeting,
      ),
    );

    if (detailsOverlayEntry != null) {
      Overlay.of(context).insert(detailsOverlayEntry!);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.meeting.title,
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
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () async {
                          if (widget.meeting.transcription.trim().isNotEmpty) {
                            bool result = await _permissionRequest();
                            if (result) {
                              downloadTextFile(widget.meeting.title,
                                  widget.meeting.transcription,
                                  onSuccess: (filePath) {
                                toastification.show(
                                  context: context,
                                  alignment: Alignment.bottomCenter,
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.minimal,
                                  autoCloseDuration: const Duration(seconds: 5),
                                  title: Text("File saved to: $filePath"),
                                  icon: const Icon(Icons.download_done_rounded),
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
                              title: const Text("The transcription is empty."),
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
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () async {
                          if (widget.meeting.transcription.trim().isNotEmpty) {
                            shareTextFile(widget.meeting.title,
                                widget.meeting.transcription);
                          } else {
                            toastification.show(
                              context: context,
                              alignment: Alignment.bottomCenter,
                              type: ToastificationType.error,
                              style: ToastificationStyle.minimal,
                              autoCloseDuration: const Duration(seconds: 2),
                              title: const Text("The transcription is empty."),
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    setState(() {
                      _showDetailsOverlay(context);
                    })
                  },
                ),
              ],
            ),
            const MeetingCardDivider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 650.0),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: (widget.meeting.endDateAtMillis != null ||
                            widget.meeting.status == MeetingStatus.ended)
                        ? Text(widget.meeting.transcription)
                        : StreamBuilder(
                            stream: stream,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null &&
                                    snapshot.data!.snapshot.exists &&
                                    snapshot.data?.snapshot.value != null) {
                                  // {data: . Bonjour.. . . Un. . deux. . . }
                                  dynamic data = snapshot.data?.snapshot.value;
                                  // set transcription
                                  _updateTranscription(data["data"],
                                      snapshot.data?.snapshot.key);
                                  return Text(
                                      "${data["data"] ?? "No Transcription"}");
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
                                return const Center(
                                  child: Text("No Transcription"),
                                );
                              }
                            }),
                  )),
            ),
            const Spacer(),
            Center(
              child: Text(
                "ID: ${widget.meeting.id}",
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
    );
  }
}

class DetailsOverlay extends StatelessWidget {
  final Function() onClose;
  final Meeting meeting;

  const DetailsOverlay(
      {super.key, required this.onClose, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      color: Colors.black.withOpacity(0.8), // Semi-transparent background
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
                          if (meeting.archived)
                            const Tooltip(
                              message: "This meeting has been archived!",
                              showDuration: Duration(seconds: 3),
                              child: FaIcon(FontAwesomeIcons.snowflake),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (meeting.favorite)
                            const Tooltip(
                              message: "This meeting is one of your favorites!",
                              showDuration: Duration(seconds: 3),
                              child: FaIcon(FontAwesomeIcons.solidHeart),
                            )
                        ],
                      ),
                    ),
                  ),
                  MeetingField(name: "meeting_title", value: meeting.title),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MeetingAttributeCard(
                        firstName: "meeting_status",
                        firstValue: meeting.status.title,
                        secondName: "meeting_schedule_date",
                        secondValue: (meeting.scheduledDateAtMillis != null
                            ? meeting.scheduledDateAtMillis!.toDateTimeString()
                            : ""),
                      ),
                      MeetingAttributeCard(
                        firstName: "meeting_creator",
                        firstValue: meeting.userName,
                        secondName: "meeting_creation_date",
                        secondValue:
                            meeting.creationDateAtMillis.toDateTimeString(),
                      ),
                    ],
                  ),
                  MeetingField(
                      name: "meeting_description", value: meeting.description),
                  MeetingField(
                      name: "meeting_end_date",
                      value: ((meeting.endDateAtMillis != null)
                          ? meeting.endDateAtMillis!.toDateTimeString()
                          : "")),
                  if (meeting.autoDeletion == true)
                    MeetingField(
                        name: "meeting_auto_delete_date",
                        value: ((meeting.autoDeletionDateAtMillis != null)
                            ? meeting.autoDeletionDateAtMillis!
                                .toDateTimeString()
                            : "")),
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
