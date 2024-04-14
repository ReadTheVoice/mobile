import 'package:flutter/material.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_card_component.dart';

class SteamedMeetingCard extends StatefulWidget {
  final Icon leftIcon;
  final Icon rightIcon;

  final Color leftColor;
  final Color rightColor;

  final Function leftFunction;
  final Function cardDeleteFunction;

  final bool? unarchiving;
  final bool? isFavoriteList;

  // New attributes
  final MeetingModel meetingModel;

  const SteamedMeetingCard(
      {super.key,
      required this.leftIcon,
      required this.rightIcon,
      required this.leftColor,
      required this.rightColor,
      required this.leftFunction,
      required this.cardDeleteFunction,
      this.unarchiving,
      this.isFavoriteList = false,
      required this.meetingModel});

  @override
  State<SteamedMeetingCard> createState() => _SteamedMeetingCardState();
}

class _SteamedMeetingCardState extends State<SteamedMeetingCard> {
  final MeetingService meetingService = const MeetingService();
  late Meeting currentMeeting;

  Future<void> initializeMeeting() async {
    var existing = await meetingService.getMeetingById(widget.meetingModel.id);
    if (existing != null) {
      currentMeeting = existing;
    } else {
      await meetingService.insertMeeting(widget.meetingModel.toMeeting());

      currentMeeting =
          (await meetingService.getMeetingById(widget.meetingModel.id))!;
    }
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
        key: ValueKey<String>(widget.meetingModel.id),
        onDismissed: (DismissDirection direction) async {
          if (direction == DismissDirection.startToEnd) {
            widget.leftFunction(widget.meetingModel.id,
                widget.meetingModel.toMeeting().archived);

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
        child: MeetingCard(
          isFavoriteList: widget.isFavoriteList,
          deleteFunction: widget.cardDeleteFunction,
          meetingModel: widget.meetingModel,
        ));
  }
}
