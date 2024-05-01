import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/app_progress_indicator_component.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/ui/component/streamed_meeting_card.dart';
import 'package:readthevoice/ui/helper/display_toast_helper.dart';
import 'package:readthevoice/ui/screen/custom_search_delegate.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:readthevoice/utils/utils.dart';

class ArchivedMeetingsScreen extends StatefulWidget {
  const ArchivedMeetingsScreen({super.key});

  @override
  State<ArchivedMeetingsScreen> createState() => _ArchivedMeetingsScreenState();
}

class _ArchivedMeetingsScreenState extends State<ArchivedMeetingsScreen> {
  final meetingService = const MeetingService();

  late List<String>? meetingIds = null;

  Future<void> initList() async {
    await refreshMeetingList();

    meetingIds =
        (await meetingService.getArchivedMeetings()).map((e) => e.id).toList();

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
        appBar: AppBar(
          title: const Text("archived_meetings_screen_title").tr(),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(
                        Theme.of(context).colorScheme.onBackground));
              },
              icon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: RefreshIndicator(
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

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }

                            return (snapshot.data != null)
                                ? ListView(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                          if (document.data() != null) {
                                            Map<String, dynamic> data =
                                                document.data()!
                                                    as Map<String, dynamic>;

                                            MeetingModel model =
                                                MeetingModel.fromFirebase(
                                                    document.id, data);

                                            // Whether the meeting is archived or not
                                            return SteamedMeetingCard(
                                              meetingModel: model,
                                              unarchiving: true,
                                              leftIcon: const Icon(
                                                  Icons.unarchive_outlined),
                                              rightIcon: const Icon(
                                                  Icons.delete_forever),
                                              leftColor: Colors.green,
                                              rightColor: Colors.red,
                                              leftFunction: (String meetingId,
                                                  bool archived) {
                                                if (archived) {
                                                  meetingService
                                                      .setArchiveMeetingById(
                                                          meetingId, false);
                                                  meetingIds?.remove(meetingId);
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
                                                      AvailableScreens
                                                          .archivedMeetings),
                                            );
                                          }
                                        })
                                        .toList()
                                        .cast(),
                                  )
                                : const NoDataWidget(
                                    currentScreen:
                                        AvailableScreens.archivedMeetings);
                          },
                        )
                      : const NoDataWidget(
                          currentScreen: AvailableScreens.archivedMeetings))
                  : const AppProgressIndicator(),
            )));
  }
}
