import 'package:flutter/material.dart';
import 'package:readthevoice/data/db/rtv_database.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/ui/component/MeetingCard.dart';

class ArchivedMeetingsScreen extends StatefulWidget {
  AppDatabase? database;

  ArchivedMeetingsScreen({super.key, this.database});

  @override
  State<ArchivedMeetingsScreen> createState() => _ArchivedMeetingsScreenState();
}

class _ArchivedMeetingsScreenState extends State<ArchivedMeetingsScreen> {
  AppDatabase? database;

  @override
  void initState() {
    super.initState();

    database = widget.database;
  }

  Future<List<Meeting>> retrieveMeetings() async {
    // if(database != null) {
    //   return await database!.meetingDao.findAllMeeting();
    // } else {
    //   return List.empty();
    // }

    // database = widget.database;
    return await database!.meetingDao.findAllArchivedMeeting();
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
                    return Dismissible(
                      // direction: DismissDirection.endToStart,
                      dismissThresholds: const {
                        DismissDirection.startToEnd: 0.75,
                        DismissDirection.endToStart: 0.75
                        // DismissDirection.startToEnd: 1.0,
                        // DismissDirection.endToStart: 1.0
                      },
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Icon(Icons.unarchive_outlined),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Icon(Icons.delete_forever),
                      ),
                      key: ValueKey<String>(snapshot.data![index].id),
                      onDismissed: (DismissDirection direction) async {
                        if(direction == DismissDirection.startToEnd) {
                          if(database != null) {
                            // archiveMeetingById
                            if(snapshot.data![index].archived) {
                              await database!.meetingDao
                                  .archiveMeetingById(
                                  snapshot.data![index].id,
                                  false);
                            }

                            setState(() {
                              snapshot.data!.remove(snapshot.data![index]);
                              // await database!.meetingDao.findAllMeeting();
                            });
                          }
                        }

                        if(direction == DismissDirection.endToStart) {
                          if(database != null) {
                            await database!.meetingDao
                                .deleteMeeting(snapshot.data![index].id);
                          }

                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        }
                      },
                      child: MeetingCard(
                        meeting: snapshot.data![index],
                        title: snapshot.data![index].title,
                        transcription: snapshot.data![index].transcription,
                      ),
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
