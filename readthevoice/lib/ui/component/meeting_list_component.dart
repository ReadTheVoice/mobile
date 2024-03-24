import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/ui/component/meeting_card.dart';

class MeetingList extends StatefulWidget {
  final List<Meeting>? meetings;

  final Icon leftIcon;
  final Icon rightIcon;

  final Color leftColor;
  final Color rightColor;

  final Function leftFunction;
  final Function rightFunction;

  const MeetingList(
      {super.key,
      this.meetings,
      required this.leftIcon,
      required this.rightIcon,
      required this.leftColor,
      required this.rightColor,
      required this.leftFunction,
      required this.rightFunction});

  @override
  State<MeetingList> createState() => _MeetingListState();
}

class _MeetingListState extends State<MeetingList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.meetings?.length,
      itemBuilder: (BuildContext context, int index) {
        Meeting? currentMeeting;

        if (widget.meetings != null) {
          currentMeeting = widget.meetings?[index];
          // currentMeeting = widget.meetings![index];
        }

        return Dismissible(
          dismissThresholds: const {
            DismissDirection.startToEnd: 0.5,
            DismissDirection.endToStart: 0.5
          },
          background: Container(
            color: widget.leftColor,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: widget.leftIcon,
          ),
          secondaryBackground: Container(
            color: widget.rightColor,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: widget.rightIcon,
          ),
          key: ValueKey<String>(currentMeeting?.id ?? ""),
          onDismissed: (DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd) {
              widget.leftFunction(
                  currentMeeting?.id ?? "", currentMeeting?.archived ?? false);

              setState(() {
                if (widget.meetings != null) {
                  widget.meetings?.remove(currentMeeting);
                }
              });
            }

            if (direction == DismissDirection.endToStart) {
              widget.rightFunction(currentMeeting?.id ?? "");

              setState(() {
                if (widget.meetings != null) {
                  widget.meetings?.remove(currentMeeting);
                }
              });
            }
          },
          child: MeetingCard(
            meeting: currentMeeting!,
            deleteFunction: () {
              setState(() {
                widget.meetings!.remove(currentMeeting);
              });
            },
          ),
        );
      },
    );
  }
}
