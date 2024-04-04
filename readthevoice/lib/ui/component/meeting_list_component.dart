import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/ui/component/meeting_card_component.dart';

class MeetingList extends StatefulWidget {
  final List<Meeting>? meetings;

  final Icon leftIcon;
  final Icon rightIcon;

  final Color leftColor;
  final Color rightColor;

  final Function leftFunction;
  final Function rightFunction;

  final bool? unarchiving;

  const MeetingList(
      {super.key,
      this.meetings,
      required this.leftIcon,
      required this.rightIcon,
      required this.leftColor,
      required this.rightColor,
      required this.leftFunction,
      required this.rightFunction, this.unarchiving});

  @override
  State<MeetingList> createState() => _MeetingListState();
}

class _MeetingListState extends State<MeetingList> {
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


  void _showConfirmationDialog(Meeting? currentMeeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded),
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
        widget.rightFunction(currentMeeting?.id ?? "");

        setState(() {
          if (widget.meetings != null) {
            widget.meetings?.remove(currentMeeting);
          }

          _showSnackBar("Deletion complete !");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.meetings?.length,
      itemBuilder: (BuildContext context, int index) {
        Meeting? currentMeeting;

        if (widget.meetings != null) {
          currentMeeting = widget.meetings?[index];
        }

        return Dismissible(
          // dismissThresholds: const {
          //   DismissDirection.startToEnd: 0.5,
          //   DismissDirection.endToStart: 0.5
          // },
          direction: DismissDirection.startToEnd,
          background: Container(
            color: widget.leftColor,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: widget.leftIcon,
          ),
          // secondaryBackground: Container(
          //   color: widget.rightColor,
          //   alignment: Alignment.centerRight,
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   child: widget.rightIcon,
          // ),
          key: ValueKey<String>(currentMeeting?.id ?? ""),
          onDismissed: (DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd) {
              widget.leftFunction(
                  currentMeeting?.id ?? "", currentMeeting?.archived ?? false);

              setState(() {
                if (widget.meetings != null) {
                  widget.meetings?.remove(currentMeeting);
                }

                String snackBarText = "Archiving complete";
                if(widget.unarchiving != null && widget.unarchiving == true) {
                  snackBarText = "Unarchiving complete";
                }

                _showSnackBar(snackBarText);
              });
            }

            // if (direction == DismissDirection.endToStart) {
            //   _showConfirmationDialog(currentMeeting);
            // }
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
