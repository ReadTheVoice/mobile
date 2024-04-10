import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/meeting_card_component.dart';
import 'package:readthevoice/utils/utils.dart';

class FavoriteMeetingsScreen extends StatefulWidget {
  const FavoriteMeetingsScreen({super.key});

  @override
  State<FavoriteMeetingsScreen> createState() => _FavoriteMeetingsScreenState();
}

class _FavoriteMeetingsScreenState extends State<FavoriteMeetingsScreen> {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();

  Future<List<Meeting>> retrieveMeetings() async {
    await refreshMeetingList();
    return await meetingService.getFavoriteMeetings();
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
                ? ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      Meeting currentMeeting = snapshot.data![index];
                      return MeetingCard(
                        meeting: currentMeeting,
                        isFavoriteList: true,
                        favoriteFunction: () {
                          setState(() {
                            snapshot.data!.remove(currentMeeting);
                          });
                        },
                        deleteFunction: () {
                          setState(() {
                            snapshot.data!.remove(currentMeeting);
                          });
                        },
                      );
                    },
                  )
                : const Text("No Data");
          } else {
            return const AppProgressIndicator();
          }
        },
      ),)
    ));
  }
}
