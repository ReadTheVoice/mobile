import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/app_progress_indicator_component.dart';
import 'package:readthevoice/ui/component/meeting_card_component.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
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
  String searchText = "";

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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              SearchBar(
                backgroundColor: (isDarkMode)
                    ? const MaterialStatePropertyAll(Color(0x55bdbdbd))
                    : const MaterialStatePropertyAll(Color(0xFFD6E3FF)),
                overlayColor: const MaterialStatePropertyAll(Color(0xFF295EA7)),
                hintText: "test",
                hintStyle: (isDarkMode)
                    ? const MaterialStatePropertyAll(
                        TextStyle(color: Colors.white60))
                    : const MaterialStatePropertyAll(
                        TextStyle(color: Colors.black38)),
                textStyle: (isDarkMode)
                    ? const MaterialStatePropertyAll(
                        TextStyle(color: Colors.white))
                    : const MaterialStatePropertyAll(
                        TextStyle(color: Colors.black)),
                onChanged: (value) {
                  // if(value.length >= 3) {
                  //   searchText = value;
                  //   initList();
                  // }

                  if (value.isEmpty) {
                    searchText = "";
                    initList();
                  }
                },
                onSubmitted: (value) {
                  searchText = value;
                  initList();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: initList,
                child: (meetingIds != null)
                    ? ((meetingIds!.isNotEmpty)
                        ? StreamBuilder<QuerySnapshot>(
                            stream: FirebaseDatabaseService()
                                .meetingCollectionReference
                                .where(FieldPath.documentId,
                                    whereIn: meetingIds)
                                .orderBy("createdAt", descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return ErrorScreen(
                                  text:
                                      "Something went wrong\n${snapshot.error}",
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }

                              var data = snapshot.data;
                              var doc = List<DocumentSnapshot>.empty();
                              if (data != null) {
                                doc = snapshot.data!.docs;
                              }

                              if (searchText.trim().isNotEmpty) {
                                doc = doc.where((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;

                                  MeetingModel model =
                                      MeetingModel.fromFirebase(
                                          document.id, data);

                                  return (model.name
                                          .toLowerCase()
                                          .contains(searchText.toLowerCase()) ||
                                      (model.description != null &&
                                          model.description!
                                              .toLowerCase()
                                              .contains(
                                                  searchText.toLowerCase())));
                                }).toList();
                              }

                              return (data != null)
                                  ? ((doc.isEmpty)
                                      ? NoMatchingMeeting(
                                          searchText: searchText)
                                      : ListView(
                                          children: doc
                                              .map((DocumentSnapshot document) {
                                                if (document.data() != null) {
                                                  Map<String, dynamic> data =
                                                      document.data()! as Map<
                                                          String, dynamic>;

                                                  MeetingModel model =
                                                      MeetingModel.fromFirebase(
                                                          document.id, data);

                                                  // Whether the meeting is archived or not
                                                  return MeetingCard(
                                                    isFavoriteList: true,
                                                    meetingModel: model,
                                                    favoriteFunction:
                                                        (String meetingId) {
                                                      setState(() {
                                                        meetingIds
                                                            ?.remove(meetingId);
                                                      });
                                                    },
                                                    deleteFunction:
                                                        (String meetingId) {
                                                      setState(() {
                                                        meetingIds
                                                            ?.remove(meetingId);
                                                      });

                                                      if (meetingIds != null &&
                                                          meetingIds!.contains(
                                                              meetingId)) {
                                                        showUnsuccessfulToast(
                                                            context,
                                                            "unsuccessful_deletion");
                                                      } else {
                                                        showSuccessfulToast(
                                                            context,
                                                            "successful_deletion");
                                                      }
                                                    },
                                                  );
                                                } else {
                                                  return const ListTile(
                                                    title: NoDataWidget(
                                                        currentScreen:
                                                            AvailableScreens
                                                                .archivedMeetings),
                                                  );
                                                }
                                              })
                                              .toList()
                                              .cast(),
                                        ))
                                  : const NoDataWidget(
                                      currentScreen:
                                          AvailableScreens.favoriteMeetings);
                            },
                          )
                        : const NoDataWidget(
                            currentScreen: AvailableScreens.favoriteMeetings))
                    : const AppProgressIndicator(),
              ))
            ])));
  }
}
