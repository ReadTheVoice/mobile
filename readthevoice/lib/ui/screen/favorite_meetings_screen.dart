import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_card_component.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/ui/component/app_progress_indicator_component.dart';
import 'package:readthevoice/ui/helper/display_toast_helper.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/utils/utils.dart';

class FavoriteMeetingsScreen extends StatefulWidget {
  const FavoriteMeetingsScreen({super.key});

  @override
  State<FavoriteMeetingsScreen> createState() => _FavoriteMeetingsScreenState();
}

class _FavoriteMeetingsScreenState extends State<FavoriteMeetingsScreen> {
  final meetingService = const MeetingService();

  late List<String>? meetingIds = null;

  Future<void> initList() async {
    await refreshMeetingList();

    meetingIds =
        (await meetingService.getFavoriteMeetings()).map((e) => e.id).toList();

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
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: initList,
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
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;

                                    MeetingModel model =
                                        MeetingModel.fromFirebase(
                                            document.id, data);

                                    // Whether the meeting is archived or not
                                    return MeetingCard(
                                      isFavoriteList: true,
                                      meetingModel: model,
                                      favoriteFunction: (String meetingId) {
                                        setState(() {
                                          meetingIds?.remove(meetingId);
                                        });
                                      },
                                      deleteFunction: (String meetingId) {
                                        setState(() {
                                          meetingIds?.remove(meetingId);
                                        });

                                        if (meetingIds != null &&
                                            meetingIds!.contains(meetingId)) {
                                          showUnsuccessfulToast(
                                              context, "unsuccessful_deletion");
                                        } else {
                                          showSuccessfulToast(
                                              context, "successful_deletion");
                                        }
                                      },
                                    );
                                  } else {
                                    return const ListTile(
                                      title: NoDataWidget(
                                          currentScreen: AvailableScreens
                                              .archivedMeetings),
                                    );
                                  }
                                })
                                .toList()
                                .cast(),
                          )
                        : const NoDataWidget(
                            currentScreen: AvailableScreens.favoriteMeetings);
                  },
                )
              : const NoDataWidget(
                  currentScreen: AvailableScreens.favoriteMeetings))
          : const AppProgressIndicator(),
    ));
  }
}
