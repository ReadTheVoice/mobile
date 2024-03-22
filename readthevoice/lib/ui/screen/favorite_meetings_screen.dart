import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_card.dart';

class FavoriteMeetingsScreen extends StatefulWidget {
  const FavoriteMeetingsScreen({super.key});

  @override
  State<FavoriteMeetingsScreen> createState() => _FavoriteMeetingsScreenState();
}

class _FavoriteMeetingsScreenState extends State<FavoriteMeetingsScreen> {
  MeetingService meetingService = const MeetingService();

  Future<List<Meeting>> retrieveMeetings() async {
    return await meetingService.getFavoriteMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
                        title: currentMeeting.title,
                        transcription: currentMeeting.transcription,
                        setFavorite: (String meetingId) {
                          meetingService.setFavoriteMeetingById(meetingId, currentMeeting.favorite);
                        },
                      );
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
