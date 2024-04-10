import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/meeting_list_component.dart';
import 'package:readthevoice/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();
  String filterText = "";

  Future<List<Meeting>> retrieveMeetings() async {
    await refreshMeetingList();

    await meetingService.insertSampleData();

    List<Meeting> currentMeetings =
        await meetingService.getUnarchivedMeetings();

    if (filterText.trim().isNotEmpty) {
      return currentMeetings
          .where((meeting) =>
              meeting.title.contains(filterText) ||
              meeting.description.contains(filterText))
          .toList();
    }

    return currentMeetings;
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        showCloseIcon: true,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void filterProductsByPrice(String textToSearch) {
    setState(() {
      filterText = textToSearch;
    });
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
          if (snapshot.hasData &&
              snapshot.connectionState != ConnectionState.none) {
            return (snapshot.data!.isNotEmpty)
                ? MeetingList(
                    meetings: snapshot.data,
                    leftIcon: const Icon(Icons.archive_outlined),
                    rightIcon: const Icon(Icons.delete_forever),
                    leftColor: Colors.green,
                    rightColor: Colors.red,
                    leftFunction: (String meetingId, bool archived) {
                      if (!archived) {
                        meetingService.setArchiveMeetingById(meetingId, true);
                      }
                    },
                    rightFunction: (String meetingId) {
                      meetingService.deleteMeetingById(meetingId);

                      _showSnackBar("Deletion complete !");
                    },
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
