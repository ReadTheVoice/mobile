import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_compoents.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/ui/component/streamed_meeting_card.dart';
import 'package:readthevoice/ui/helper/display_toast_helper.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  String? newMeetingId = null;

  HomeScreen({super.key, this.newMeetingId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final meetingService = const MeetingService();

  late List<String>? meetingIds = null;

  Future<void> initList() async {
    await refreshMeetingList();

    meetingIds = (await meetingService.getUnarchivedMeetings())
        .map((e) => e.id)
        .toList();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.newMeetingId != null) {
      meetingIds?.add(widget.newMeetingId!);
      widget.newMeetingId = null;
    }

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: RefreshIndicator(
            onRefresh: initList,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
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

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingScreen();
                          }

                          return (snapshot.data != null)
                              ? ListView(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                        if (document.data() != null) {
                                          Map<String, dynamic> data = document
                                              .data()! as Map<String, dynamic>;

                                          MeetingModel model =
                                              MeetingModel.fromFirebase(
                                                  document.id, data);

                                          return SteamedMeetingCard(
                                            meetingModel: model,
                                            leftIcon: const Icon(
                                                Icons.archive_outlined),
                                            rightIcon: const Icon(
                                                Icons.delete_forever),
                                            leftColor: Colors.green,
                                            rightColor: Colors.red,
                                            leftFunction: (String meetingId,
                                                bool archived) {
                                              if (!archived) {
                                                meetingService
                                                    .setArchiveMeetingById(
                                                        meetingId, true);
                                                setState(() {
                                                  meetingIds?.remove(meetingId);
                                                  // initList();
                                                });
                                              }

                                              setState(() {});
                                            },
                                            cardDeleteFunction:
                                                (String meetingId) {
                                              setState(() {
                                                meetingIds?.remove(meetingId);
                                              });

                                              if (meetingIds != null &&
                                                  meetingIds!
                                                      .contains(meetingId)) {
                                                showUnsuccessfulToast(context,
                                                    "unsuccessful_deletion");
                                              } else {
                                                showSuccessfulToast(context,
                                                    "successful_deletion");
                                              }
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
                : const AppProgressIndicator()),
      ),
    );
  }
}
