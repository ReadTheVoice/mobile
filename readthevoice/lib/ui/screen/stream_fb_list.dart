import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/ui/component/streamed_meeting_card.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/utils/utils.dart';

class StreamFbList extends StatefulWidget {
  const StreamFbList({super.key});

  @override
  State<StreamFbList> createState() => _StreamFbListState();
}

class _StreamFbListState extends State<StreamFbList> {
  final meetingService = const MeetingService();

  late List<String>? meetingIds = null;

  Future<void> initList() async {
    await refreshMeetingList();

    meetingIds =
        (await meetingService.getUnarchivedMeetings()).map((e) => e.id).toList();
        // (await meetingService.getAllMeetings()).map((e) => e.id).toList();
    print("meetingIds".toUpperCase());
    print(meetingIds);

    setState(() {
      // print(meetingIds);
    });
  }

  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    return (meetingIds != null)
        ? ((meetingIds!.isNotEmpty)
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseDatabaseService()
                    .meetingCollectionReference
                    .where(FieldPath.documentId, whereIn: meetingIds)
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(
                      text: "Something went wrong\n${snapshot.error}",
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return (snapshot.data != null)
                      ? ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                                if (document.data() != null) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;

                                  print("data".toUpperCase());
                                  print(data);

                                  MeetingModel model = MeetingModel.fromFirebase(document.id, data);
                                  MeetingStatus status = model.getMeetingStatus();

                                  var id = document.id;
                                  var createdDate = DateTime.fromMillisecondsSinceEpoch((data['createdAt'] as Timestamp).millisecondsSinceEpoch);
                                  var creatorId = data['creator'];
                                  var title = data['name'];
                                  var description = data['description'] ?? "";

                                  // Whether the meeting is archived or not

                                  return SteamedMeetingCard(
                                    currentMeeting: Meeting.example(document.id),
                                    meetingModel: model,
                                    leftIcon: const Icon(Icons.archive_outlined),
                                    rightIcon: const Icon(Icons.delete_forever),
                                    leftColor: Colors.green,
                                    rightColor: Colors.red,
                                    leftFunction: (String meetingId, bool archived) {
                                      if (!archived) {
                                        meetingService.setArchiveMeetingById(meetingId, true);
                                        meetingIds?.remove(meetingId);
                                      }

                                      setState(() { });
                                    },
                                    cardDeleteFunction: (String meetingId) {
                                      meetingService.deleteMeetingById(meetingId);
                                      meetingIds?.remove(meetingId);
                                      setState(() { });
                                    },
                                  );
                                  // return StreamedCard(meeting: Meeting.example(document.id), meetingModel: model,);
                                } else {
                                  return const ListTile(
                                    title: NoDataWidget(
                                        currentScreen:
                                            AvailableScreens.streamFbList),
                                  );
                                }
                              })
                              .toList()
                              .cast(),
                        )
                      : const NoDataWidget(
                          currentScreen: AvailableScreens.streamFbList);
                },
              )
            : const NoDataWidget(currentScreen: AvailableScreens.streamFbList))
        : const AppPlaceholder();
  }

/*
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();
  String filterText = "";
  Timer? _timer;

  // Future<Stream<QuerySnapshot<Object?>>> rt() async {
  Future<Stream<QuerySnapshot>> rt() async {
    return await firebaseService.meetingCollectionReference.orderBy("createdAt", descending: true).snapshots();
  }

  Future<List<Meeting>> retrieveMeetings() async {
    await refreshMeetingList();

    // setState(() {
    //   // meetingService.getAllMeetings();
    //   meetingService.getUnarchivedMeetings().then((value) => null);
    // });

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

  @override
  void initState() {
    super.initState();
    retrieveMeetings();
    // _timer = Timer.periodic(const Duration(minutes: 5), (_) => retrieveMeetings);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                        : const NoDataWidget(currentScreen: AvailableScreens.home,);
                  } else {
                    return const AppProgressIndicator();
                  }
                },
              ),
            )));
  }
  */
}
