import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meeting.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                "ID: ${widget.meeting.id}",
                style: const TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // Streaming screen
            Text(
              "Transcription: ${widget.meeting.transcription}",
              style: const TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
