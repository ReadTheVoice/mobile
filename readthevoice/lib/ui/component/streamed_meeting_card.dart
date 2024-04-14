import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';
import 'package:readthevoice/ui/component/meeting_card_component.dart';
import 'package:readthevoice/ui/screen/meeting_screen.dart';
import 'package:readthevoice/utils/utils.dart';
import 'package:toastification/toastification.dart';

class SteamedMeetingCard extends StatefulWidget {
  final Meeting currentMeeting;

  final Icon leftIcon;
  final Icon rightIcon;

  final Color leftColor;
  final Color rightColor;

  final Function leftFunction;
  final Function cardDeleteFunction;

  final bool? unarchiving;
  final bool? isFavoriteList;

  // New attributes
  final MeetingModel? meetingModel;

  const SteamedMeetingCard(
      {super.key,
      required this.currentMeeting,
      required this.leftIcon,
      required this.rightIcon,
      required this.leftColor,
      required this.rightColor,
      required this.leftFunction,
      required this.cardDeleteFunction,
      this.unarchiving,
      this.isFavoriteList = false, this.meetingModel});

  @override
  State<SteamedMeetingCard> createState() => _SteamedMeetingCardState();
}

class _SteamedMeetingCardState extends State<SteamedMeetingCard> {
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

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
        color: widget.leftColor,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: widget.leftIcon,
      ),
      key: ValueKey<String>(widget.currentMeeting.id ?? ""),
      onDismissed: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.leftFunction(
              widget.currentMeeting.id, widget.currentMeeting.archived);

          setState(() {
            // if (widget.meetings != null) {
            //   widget.meetings?.remove(widget.currentMeeting);
            // }

            String snackBarText = "Archiving complete";
            if (widget.unarchiving != null && widget.unarchiving == true) {
              snackBarText = "Unarchiving complete";
            }

            _showSnackBar(snackBarText);
          });
        }
      },
      child: StreamedCard(
        meeting: widget.currentMeeting,
        isFavoriteList: widget.isFavoriteList,
        deleteFunction: widget.cardDeleteFunction,
        meetingModel: widget.meetingModel,
      )
    );
  }
}

class StreamedCard extends StatefulWidget {
  final Meeting meeting;
  final Color? background;
  final Color? textColor;

  final bool? isFavoriteList;

  final Function? favoriteFunction;
  final Function? deleteFunction;

  final MeetingModel? meetingModel;

  /*
      MeetingStatus status = model.getMeetingStatus();

      var id = document.id;
      var createdDate = DateTime.fromMillisecondsSinceEpoch((data['createdAt'] as Timestamp).millisecondsSinceEpoch);
      var creatorId = data['creator'];
      var title = data['name'];
      var description = data['description'] ?? "";
   */

  const StreamedCard(
      {super.key,
      required this.meeting,
      this.isFavoriteList,
      this.favoriteFunction,
      this.deleteFunction,
      this.background,
      this.textColor = Colors.white, this.meetingModel});

  @override
  State<StreamedCard> createState() => _StreamedCardState();
}

class _StreamedCardState extends State<StreamedCard> {
  final MeetingService meetingService = const MeetingService();
  late final MeetingModel meetingModel;
  late final MeetingST currentMeeting;

  Future<void> initializeAttributes() async {
    meetingModel = widget.meetingModel ?? MeetingModel.example();
    var existing = await meetingService.getMeetingById(meetingModel.id);
    if(existing != null) {
      // currentMeeting = await meetingService.getMeetingById(meetingModel.id);
    } else {
      // MeetingST inserting = MeetingST(id: id, userId: userId);
      // await meetingService.insertMeeting(meeting);

      // currentMeeting = await meetingService.getMeetingById(meetingModel.id);
    }

    setState(() { });
  }

  @override
  void initState() {
    super.initState();
    initializeAttributes();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to perform this action ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed ?? false) {
        setState(() {
          if (widget.deleteFunction != null) {
            widget.deleteFunction!(meetingModel.id);
          }

          toastification.show(
            context: context,
            alignment: Alignment.bottomCenter,
            type: ToastificationType.success,
            style: ToastificationStyle.minimal,
            autoCloseDuration: const Duration(seconds: 5),
            title: const Text('Successfully deleted.'),
            // description: RichText(text: const TextSpan(text: 'This is a sample toast message. ')),
            icon: const FaIcon(FontAwesomeIcons.circleCheck),
            primaryColor: Colors.green,
            // backgroundColor: Colors.white,
            // foregroundColor: Colors.black,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingScreen(
              // meetingModel OR meetingModel.id
              meeting: widget.meeting,
              meetingModel: widget.meetingModel,
            ),
          ),
        );
      },
      child: Card(
          color: widget.background ??
              Theme.of(context).colorScheme.primaryContainer,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  // widget.meeting.title.trim() != ""
                  meetingModel.name.trim() != ""
                      // ? widget.meeting.title
                      ? meetingModel.name
                      : "Title: ...",
                  style: TextStyle(color: widget.textColor, fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // MeetingStatusChip(meetingStatus: widget.meeting.status),
                MeetingStatusChip(meetingStatus: meetingModel.getMeetingStatus()),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MeetingCardDivider(),
                const MeetingCardDivider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth - 150,  // Here
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isFavoriteList != null &&
                                widget.isFavoriteList == true &&
                                widget.meeting.archived)
                                // widget.meeting.archived)
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.snowflake,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "meeting_is_archived",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                                  ).tr()
                                ],
                              ),
                            Text(
                              meetingModel.description ?? "",
                              // widget.meeting.description,
                              style: TextStyle(
                                  color: widget.textColor, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                bool fav = !widget.meeting.favorite;

                                widget.meeting.favorite = fav;
                                meetingService.setFavoriteMeetingById(
                                    meetingModel.id, fav);
                                    // widget.meeting.id, fav);

                                if (widget.favoriteFunction != null) {
                                  widget.favoriteFunction!();
                                }
                              });
                            },
                            icon: Icon(
                              widget.meeting.favorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: widget.textColor,
                            )),
                        IconButton(
                            onPressed: _showConfirmationDialog,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: widget.textColor,
                            ))
                      ],
                    ),
                  ],
                ),
                const MeetingCardDivider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    "${tr("meeting_creation_date")}: ${meetingModel.createdAt.toString()}",
                    // "${tr("meeting_creation_date")}: ${widget.meeting.creationDateAtMillis.toDateTimeString()}",
                    style: TextStyle(
                        color:
                        Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
