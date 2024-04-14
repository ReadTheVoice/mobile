import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/ui/component/streamed_meeting_card.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final meetingService = const MeetingService();

  late List<String>? meetingIds = null;

  Future<void> initList() async {
    await refreshMeetingList();

    print("init list of meetings".toUpperCase());

    meetingIds = (await meetingService.getUnarchivedMeetings())
        .map((e) => e.id)
        .toList();

    if(mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: refreshMeetingList,
        child: (meetingIds != null)
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
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;

                                      MeetingModel model = MeetingModel.fromFirebase(document.id, data);

                                      // Whether the meeting is archived or not
                                      return SteamedMeetingCard(
                                        meetingModel: model,
                                        leftIcon:
                                            const Icon(Icons.archive_outlined),
                                        rightIcon:
                                            const Icon(Icons.delete_forever),
                                        leftColor: Colors.green,
                                        rightColor: Colors.red,
                                        leftFunction:
                                            (String meetingId, bool archived) {
                                          if (!archived) {
                                            meetingService
                                                .setArchiveMeetingById(
                                                    meetingId, true);
                                            meetingIds?.remove(meetingId);
                                          }

                                          setState(() {});
                                        },
                                        cardDeleteFunction: (String meetingId) {
                                          meetingService
                                              .deleteMeetingById(meetingId);
                                          meetingIds?.remove(meetingId);
                                          setState(() {});
                                        },
                                      );
                                    } else {
                                      return const ListTile(
                                        title: NoDataWidget(
                                            currentScreen:
                                                AvailableScreens.home),
                                      );
                                    }
                                  })
                                  .toList()
                                  .cast(),
                            )
                          : const NoDataWidget(
                              currentScreen: AvailableScreens.home);
                    },
                  )
                : const NoDataWidget(currentScreen: AvailableScreens.home))
            : const AppPlaceholder());
  }
}
