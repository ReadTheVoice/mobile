import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
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
    stream = await firebaseService.streamMeetingTranscription(
        widget.meeting.id, widget.meeting.transcriptionId);
    // "8DXYXPDUTnPKXiWl2FtH", null);
    // widget.meeting.id, widget.meeting.transcriptionId ?? "-Nudk2kSHYQa05lHkfWj");
  }

  Future<void> _updateTranscription(
      dynamic data, String? transcriptionId) async {
    await meetingService.updateMeetingTranscription(
        widget.meeting.id, data, transcriptionId);
  }

  @override
  void initState() {
    super.initState();
    _getStream();
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
            MeetingField(name: "meeting_title", value: widget.meeting.title),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MeetingAttributeCard(
                  firstName: "meeting_status",
                  firstValue: widget.meeting.status.title,
                  secondName: "meeting_schedule_date",
                  secondValue: (widget.meeting.scheduledDateAtMillis != null
                      ? widget.meeting.scheduledDateAtMillis!.toDateTimeString()
                      : ""),
                ),
                MeetingAttributeCard(
                  firstName: "meeting_creator",
                  firstValue: widget.meeting.userName,
                  secondName: "meeting_creation_date",
                  secondValue:
                      widget.meeting.creationDateAtMillis.toDateTimeString(),
                ),
              ],
            ),
            MeetingField(
                name: "meeting_description",
                value: widget.meeting.description ?? ""),
            MeetingField(
                name: "meeting_end_date",
                value: ((widget.meeting.endDateAtMillis != null)
                    ? widget.meeting.endDateAtMillis!.toDateTimeString()
                    : "")),
            MeetingField(
                name: "meeting_auto_delete_date",
                value: ((widget.meeting.autoDeletion == true &&
                        widget.meeting.autoDeletionDateAtMillis != null)
                    ? widget.meeting.autoDeletionDateAtMillis!
                        .toDateTimeString()
                    : "")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "meeting_transcription",
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline),
                  ).tr(),
                  // If meeting ended ? Text else StreamBuilder
                  Text(widget.meeting.transcription),
                  StreamBuilder(
                      stream: stream,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          if (snapshot.data != null &&
                              snapshot.data!.snapshot.exists &&
                              snapshot.data?.snapshot.value != null) {
                            // {data: . Bonjour.. . . Un. . deux. . . , email_user: gaetan.glh@orange.fr, meeting_id: 8DXYXPDUTnPKXiWl2FtH, start: 18.65}
                            dynamic data = snapshot.data?.snapshot.value;

                            // print("SNAPSHOT DATA");
                            // print(snapshot.data?.snapshot.value);
                            // print(snapshot.data?.snapshot.key);

                            // set transcriptionId
                            _updateTranscription(
                                data["data"], snapshot.data?.snapshot.key);
                            return Text("${data["data"] ?? "No Data"}");
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
