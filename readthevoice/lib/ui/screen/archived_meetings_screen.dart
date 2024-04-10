import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/meeting_list_component.dart';
import 'package:readthevoice/utils/utils.dart';

class ArchivedMeetingsScreen extends StatefulWidget {
  const ArchivedMeetingsScreen({super.key});

  @override
  State<ArchivedMeetingsScreen> createState() => _ArchivedMeetingsScreenState();
}

class _ArchivedMeetingsScreenState extends State<ArchivedMeetingsScreen> {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();

  Future<List<Meeting>> retrieveMeetings() async {
    await refreshMeetingList();
    return await meetingService.getArchivedMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: RefreshIndicator(
      onRefresh: refreshMeetingList,
      child: FutureBuilder(
        future: retrieveMeetings(),
        builder: (BuildContext context, AsyncSnapshot<List<Meeting>> snapshot) {
          if (snapshot.hasData) {
            return (snapshot.data!.isNotEmpty)
                ? MeetingList(
                    meetings: snapshot.data,
                    leftIcon: const Icon(Icons.unarchive_outlined),
                    rightIcon: const Icon(Icons.delete_forever),
                    leftColor: Colors.green,
                    rightColor: Colors.red,
                    leftFunction: (String meetingId, bool archived) {
                      if (archived) {
                        meetingService.setArchiveMeetingById(meetingId, false);
                      }
                    },
                    rightFunction: (String meetingId) {
                      meetingService.deleteMeetingById(meetingId);
                    },
                    unarchiving: true,
                  )
                : const Text("No Data");
          } else {
            return const AppProgressIndicator();
          }
        },
      ),
    )));
  }
}
