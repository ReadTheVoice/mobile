import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/basic_components.dart';
import 'package:readthevoice/ui/component/meeting_list_component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MeetingService meetingService = const MeetingService();
  String filterText = "";

  Future<List<Meeting>> retrieveMeetings() async {
    await meetingService.insertSampleData();

    setState(() {
      meetingService.getAllMeetings();
    });

    List<Meeting> currentMeetings =
        await meetingService.getUnarchivedMeetings();

    if (filterText.trim().isNotEmpty) {
      return currentMeetings
          .where((meeting) =>
              meeting.title.contains(filterText) ||
              (meeting.description != null &&
                  meeting.description!.contains(filterText)))
          .toList();
    }

    return currentMeetings;
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        // action: SnackBarAction(
        //   label: 'Confirm',
        //   onPressed: () => print('Action confirmed!'),
        // ),
      ),
    );
  }

  void filterProductsByPrice(String textToSearch) {
    setState(() {
      filterText = textToSearch;
    });
  }

  /*
  AnimatedSearchBar(
  label: "Search Something Here",
  onChanged: (value) {
    debugPrint("value on Change");
    setState(() {
      searchText = value;
    });
  },
),
   */

  @override
  Widget build(BuildContext context) {
    /*
    title: TextField(
          autofocus: true,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          controller: _textEditingController,
          onChanged: setSearchInput,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Where are you going?',
            suffixIcon: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                _textEditingController.clear();
                setSearchInput('');
              },
            ),
          ),
        ),
     */

    return Scaffold(
        body: Center(
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
                      : const Text("No Data");
                } else {
                  return const AppProgressIndicator();
                }
              },
                ),
    ));
  }
}
