import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:toastification/toastification.dart';

class MeetingCard extends StatefulWidget {
  final Meeting meeting;
  final Color background = Colors.teal;
  final Color textColor = Colors.white;

  final bool? isFavoriteList;

  final Function? favoriteFunction;
  final Function? deleteFunction;

  const MeetingCard(
      {super.key,
      required this.meeting,
      this.isFavoriteList,
      this.favoriteFunction,
      this.deleteFunction});

  @override
  State<MeetingCard> createState() => _MeetingCardState();
}

class _MeetingCardState extends State<MeetingCard> {
  final MeetingService meetingService = const MeetingService();

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
          meetingService.deleteMeetingById(widget.meeting.id);

          if (widget.deleteFunction != null) {
            widget.deleteFunction!();
          }

          toastification.show(
            context: context,
            alignment: Alignment.bottomCenter,
            type: ToastificationType.success,
            // style: ToastificationStyle.flat,
            style: ToastificationStyle.minimal,
            autoCloseDuration: const Duration(seconds: 5),
            title: const Text('Hello, world!'),
            // you can also use RichText widget for title and description parameters
            // description: RichText(text: const TextSpan(text: 'This is a sample toast message. ')),
            icon: const Icon(Icons.check),
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
    return Card(
        color: widget.background,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10.0),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.meeting_room_outlined,
                color: widget.textColor,
              ),
              Flexible(
                child: Text(widget.meeting.title,
                    style: TextStyle(
                      color: widget.textColor,
                    )),
              ),
              const SizedBox(width: 10.0),
              if (widget.isFavoriteList != null &&
                  widget.isFavoriteList == true &&
                  widget.meeting.archived)
                Icon(
                  Icons.ac_unit_rounded,
                  color: widget.textColor,
                )
              else
                const Text(""),
            ],
          ),
          subtitle: Text(
            "${widget.meeting.transcription} \n ${widget.meeting.id}",
            style: TextStyle(
              color: widget.textColor,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      bool fav = !widget.meeting.favorite;

                      widget.meeting.favorite = fav;
                      meetingService.setFavoriteMeetingById(
                          widget.meeting.id, fav);

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
        ));
  }
}
