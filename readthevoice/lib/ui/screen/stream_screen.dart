import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';

class StreamScreen extends StatefulWidget {
  final Meeting meeting;

  // const StreamScreen({super.key, required this.meetingId, [this.meeting]});
  const StreamScreen({super.key, required this.meeting});

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

/*
//database referene.
var recentJobsRef =  recentJobsRef = FirebaseDatabase.instance.reference().child('recent').orderByChild('created_at')  //order by creation time..limitToFirst(10);
//limited to get only 10 documents.
//Now you can use stream builder to get the data.
StreamBuilder(stream: recentJobsRef.onValue,builder: (context, snap) {if (snap.hasData && !snap.hasError && snap.data.snapshot.value!=null) {

//taking the data snapshot.
DataSnapshot snapshot = snap.data.snapshot;

List item=[];
List _list=[];

//it gives all the documents in this list._list=snapshot.value;
//Now we're just checking if document is not null then add it to another list called "item".
//I faced this problem it works fine without null check until you remove a document and then your stream reads data including the removed one with a
null value(if you have some better approach let me know)._list.forEach((f){

if(f!=null){
item.add(f);
     }
    }
  );return snap.data.snapshot.value == null
  //return sizedbox if there's nothing in database.
? SizedBox()//otherwise return a list of widgets.
: ListView.builder(scrollDirection: Axis.horizontal,itemCount: item.length,
itemBuilder: (context, index) {return _containerForRecentJobs(item[index]['title']);},);} else {return   Center(child: CircularProgressIndicator());}},),
 */

class _StreamScreenState extends State<StreamScreen> {
  MeetingService meetingService = const MeetingService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meeting test"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                widget.meeting.id,
                style: const TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Image.network(
              // Image.asset(
              "https://cdn.pixabay.com/photo/2024/02/29/12/41/woman-8604350_960_720.jpg",
              height: 200,
              width: 200,
            ),
            SvgPicture.asset(
              "assets/images/svg/372-Beauty.svg",
              semanticsLabel: 'My SVG Image',
              height: 200,
              width: 200,
              // allowDrawingOutsideViewBox: true,
            ),
            Text(
              "ID: ${widget.meeting.id}",
              style: const TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/*
// Display the list of streams
  body: RefreshIndicator(
    onRefresh: () => _getStreams(),
    child: !_isRetrieving && _streams != null
        ? _streams!.isEmpty
            ? const Center(
                child: Text('Empty'),
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _streams!.length,
                itemBuilder: (context, index) {
                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(_streams![index].createdAt) * 1000,
                  );
                  DateFormat formatter =
                      DateFormat.yMMMMd().addPattern('|').add_jm();
                  String dateTimeString = formatter.format(dateTime);

                  String currentStatus = _streams![index].status;
                  bool isReady = currentStatus == 'active';

                  String? playbackId =
                      isReady ? _streams![index].playbackIds[0].id : null;

                  String? thumbnailURL = isReady
                      ? '$muxImageBaseUrl/$playbackId/$imageTypeSize'
                      : null;

                  return VideoTile(
                    streamData: _streams![index],
                    thumbnailUrl: thumbnailURL,
                    isReady: isReady,
                    dateTimeString: dateTimeString,
                    onTap: (id) async {
                      await _muxClient.deleteLiveStream(liveStreamId: id);
                      _getStreams();
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(
                  height: 16.0,
                ),
              )
        : const Center(
            child: CircularProgressIndicator(),
          ),
  ),
 */
