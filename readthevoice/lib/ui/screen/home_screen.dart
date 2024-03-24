import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_list_component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MeetingService meetingService = const MeetingService();

  Future<List<Meeting>> retrieveMeetings() async {
    await meetingService.insertSampleData();

    setState(() {
      meetingService.getAllMeetings();
    });

    return await meetingService.getUnarchivedMeetings();
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        // action: SnackBarAction(
        //   label: 'Confirm',
        //   onPressed: () => print('Action confirmed!'),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.teal,
            ));
          }
        },
      ),
    ));
  }
}
