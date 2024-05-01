import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/utils/utils.dart';

class CustomSearchDelegate extends SearchDelegate {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();

  final Color textColor;

  CustomSearchDelegate(this.textColor) {
    initList();
  }

  List<MeetingModel> results = List.empty();

  Future<void> initList() async {
    var meetings = await meetingService.getAllMeetings();

    var mtIds = [
      "ACb3Yoa7mipNPp9w7DWV",
      "DKImtUhslZ58xNDBwy3l",
      "EmQ5jKfbG9un9QVsrodK",
      "OgMdJEdcMAuf5wtGS7sK"
    ];

    // if (meetings.isNotEmpty) {
    if (mtIds.isNotEmpty) {
      // var meetingIds = meetings.map((e) => e.id).toList();
      var meetingIds = mtIds.toList();
      var models = await firebaseService.meetingCollectionReference
          .where(FieldPath.documentId, whereIn: meetingIds)
          .orderBy("createdAt", descending: true)
          .get();

      var docs = models.docs;
      results = docs.map((document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

        return MeetingModel.fromFirebase(document.id, data);
      }).toList();
    }
  }

  @override
  TextStyle? get searchFieldStyle => TextStyle(color: textColor);

  @override
  PreferredSizeWidget? buildBottom(BuildContext context) {
    // Think about building a row with chips to select
    return PreferredSize(
        preferredSize: const Size(5, 5),
        child: Divider(
          thickness: 2,
          color: Theme.of(context).colorScheme.onBackground,
        ));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return displayResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return displayResults(context);
  }

  Widget displayResults(BuildContext context) {
    List<MeetingModel> finalResults = results
        .where((element) =>
            element.name.contains(query) ||
            (element.description != null &&
                element.description!.contains(query)))
        .toList();

    return (results.isEmpty)
        ? const NoDataWidget(
            currentScreen: AvailableScreens.customSearchDelegate)
        : ((query.isNotEmpty)
            ? NoMatchingMeeting(searchText: query)
            : ListView.builder(
                itemCount: finalResults.length,
                itemBuilder: (context, index) {
                  var result = finalResults[index];
                  return ListTile(
                    title: Text(
                      result.name,
                    ),
                    subtitle: Text(
                      result.description ?? "",
                      maxLines: 2,
                    ),
                    textColor: Theme.of(context).colorScheme.onBackground,
                  );
                },
              ));
  }
}
