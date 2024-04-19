import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/ui/component/streamed_meeting_card.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/utils/utils.dart';
import 'package:toastification/toastification.dart';

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
  Widget build(BuildContext context) {
    if (widget.newMeetingId != null) {
      meetingIds?.add(widget.newMeetingId!);
      widget.newMeetingId = null;
    }

    return Scaffold(
      body: RefreshIndicator(
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
                          return const Text("Loading");
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
                                          rightIcon:
                                              const Icon(Icons.delete_forever),
                                          leftColor: Colors.green,
                                          rightColor: Colors.red,
                                          leftFunction: (String meetingId,
                                              bool archived) {
                                            if (!archived) {
                                              meetingService
                                                  .setArchiveMeetingById(
                                                      meetingId, true);
                                              meetingIds?.remove(meetingId);
                                            }

                                            setState(() {});
                                          },
                                          cardDeleteFunction:
                                              (String meetingId) async {
                                            await meetingService
                                                .deleteMeetingById(meetingId);

                                            meetingIds?.remove(meetingId);

                                            setState(() {
                                              toastification.show(
                                                context: context,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                type:
                                                    ToastificationType.success,
                                                style:
                                                    ToastificationStyle.minimal,
                                                autoCloseDuration:
                                                    const Duration(seconds: 5),
                                                title: const Text(
                                                        'successful_deletion')
                                                    .tr(),
                                                icon: const FaIcon(
                                                    FontAwesomeIcons
                                                        .circleCheck),
                                                primaryColor: Colors.green,
                                              );
                                            });
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
              : const AppPlaceholder()),
    );
  }
}
