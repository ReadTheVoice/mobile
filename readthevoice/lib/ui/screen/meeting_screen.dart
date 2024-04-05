import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';
import 'package:readthevoice/utils/utils.dart';

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

  Future<void> _getStream() async {
    // /transcripts/-Nudk2kSHYQa05lHkfWj
    stream =
        await firebaseService.streamMeetingTranscription(widget.meeting.id);
    // "8DXYXPDUTnPKXiWl2FtH");
  }

  Future<void> _updateTranscription(
      dynamic data, String? transcriptionId) async {
    await meetingService.updateMeetingTranscription(widget.meeting.id, data);
  }

  @override
  void initState() {
    super.initState();
    _getStream();
  }

  OverlayEntry? detailsOverlayEntry; // Variable to hold the OverlayEntry

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
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                            ),
                            const Text("download_transcript",
                                style: TextStyle(
                                  color: Colors.white,
                                )).tr()
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              color: Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // If meeting ended ? Text else StreamBuilder
                  // Text(widget.meeting.transcription),
                  StreamBuilder(
                      stream: stream,
                      builder: (BuildContext context, snapshot) {
                        // if (snapshot.hasData && !snapshot.hasError) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null &&
                              snapshot.data!.snapshot.exists &&
                              snapshot.data?.snapshot.value != null) {
                            // {data: . Bonjour.. . . Un. . deux. . . , email_user: gaetan.glh@orange.fr, meeting_id: 8DXYXPDUTnPKXiWl2FtH, start: 18.65}
                            dynamic data = snapshot.data?.snapshot.value;

                            print("SNAPSHOT DATA");
                            print(snapshot.data?.snapshot.value);
                            // print(snapshot.data?.snapshot.key);

                            // set transcriptionId
                            _updateTranscription(
                                data["data"], snapshot.data?.snapshot.key);
                            return Text("${data["data"] ?? "No Data"}");
                          }

                          if (snapshot.hasError) {
                            print("SNAPSHOT ERROR");
                            print(snapshot.error);
                          }

                          return const Center(
                            child: Text("No Data"),
                          );
                        } else if (snapshot.hasError) {
                          print("SNAPSHOT ERROR");
                          print(snapshot.error);

                          return Text("Error: \n${snapshot.error}");
                        } else {
                          if (widget.meeting.status == MeetingStatus.ended) {
                            return const Center(
                              child: Text("No Data"),
                            );
                          }
                          // return const Center(
                          //   child: AppPlaceholder(),
                          // );

                          return const Center(
                            child: Text("No Data"),
                          );
                        }
                      })
                ],
              ),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(children: [
          Center(
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
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
                    name: "meeting_description",
                    value: meeting.description ?? ""),
                MeetingField(
                    name: "meeting_end_date",
                    value: ((meeting.endDateAtMillis != null)
                        ? meeting.endDateAtMillis!.toDateTimeString()
                        : "")),
                MeetingField(
                    name: "meeting_auto_delete_date",
                    value: ((meeting.autoDeletion == true &&
                            meeting.autoDeletionDateAtMillis != null)
                        ? meeting.autoDeletionDateAtMillis!.toDateTimeString()
                        : "")),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            right: 20.0,
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
    ));
  }
}
