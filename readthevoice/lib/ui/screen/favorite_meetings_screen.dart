import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/meeting_card_component.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/utils/utils.dart';
import 'package:toastification/toastification.dart';

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

    print("init list of meetings".toUpperCase());

    meetingIds =
        (await meetingService.getFavoriteMeetings()).map((e) => e.id).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: RefreshIndicator(
      onRefresh: initList,
      // onRefresh: refreshMeetingList,
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

                                    MeetingModel model = MeetingModel.fromFirebase(document.id, data);

                                    // Whether the meeting is archived or not
                                    return MeetingCard(
                                      isFavoriteList: true,
                                      meetingModel: model,
                                      favoriteFunction: (String meetingId) {
                                        meetingIds?.remove(meetingId);
                                        setState(() {});
                                      },
                                      deleteFunction: (String meetingId) {
                                        meetingService
                                            .deleteMeetingById(meetingId);
                                        meetingIds?.remove(meetingId);
                                        setState(() {
                                          toastification.show(
                                            context: context,
                                            alignment: Alignment.bottomCenter,
                                            type: ToastificationType.success,
                                            style: ToastificationStyle.minimal,
                                            autoCloseDuration: const Duration(seconds: 5),
                                            title: const Text('successful_deletion').tr(),
                                            // description: RichText(text: const TextSpan(text: 'This is a sample toast message. ')),
                                            icon: const FaIcon(FontAwesomeIcons.circleCheck),
                                            primaryColor: Colors.green,
                                            // backgroundColor: Colors.white,
                                            // foregroundColor: Colors.black,
                                          );
                                        });
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
                            currentScreen: AvailableScreens.archivedMeetings);
                  },
                )
              : const NoDataWidget(
                  currentScreen: AvailableScreens.archivedMeetings))
          : const AppPlaceholder(),
    )));
  }
}
