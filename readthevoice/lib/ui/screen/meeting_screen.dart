import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';

class MeetingScreen extends StatefulWidget {
  final Meeting meeting;

  const MeetingScreen({super.key, required this.meeting});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String attributeName = "meeting_description";

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
                ),
                MeetingAttributeCard(
                  firstName: "meeting_creator",
                  firstValue: widget.meeting.userName,
                  secondName: "meeting_creation_date",
                ),
              ],
            ),
            MeetingField(
                name: "meeting_description",
                value: widget.meeting.description ?? ""),
            MeetingField(
                name: "meeting_end_date",
                value: ((widget.meeting.endDateAtMillis != null)
                    ? DateTime.fromMillisecondsSinceEpoch(
                            widget.meeting.endDateAtMillis!)
                        .toString()
                    : "")),
            MeetingField(
                name: "meeting_auto_delete_date",
                value: ((widget.meeting.autoDeletion == true &&
                        widget.meeting.autoDeletionDateAtMillis != null)
                    ? DateTime.fromMillisecondsSinceEpoch(
                            widget.meeting.autoDeletionDateAtMillis!)
                        .toString()
                    : "")),
            MeetingField(
                name: "meeting_transcription",
                value: widget.meeting.transcription),
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
