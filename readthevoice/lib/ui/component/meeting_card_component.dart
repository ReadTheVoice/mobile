import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';
import 'package:readthevoice/ui/screen/meeting_screen.dart';
import 'package:readthevoice/utils/utils.dart';
import 'package:toastification/toastification.dart';

class MeetingCard extends StatefulWidget {
  final Meeting meeting;
  final Color? background;
  final Color? textColor;

  final bool? isFavoriteList;

  final Function? favoriteFunction;
  final Function? deleteFunction;

  const MeetingCard(
      {super.key,
      required this.meeting,
      this.isFavoriteList,
      this.favoriteFunction,
      this.deleteFunction,
      this.background,
      this.textColor = Colors.white});

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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingScreen(
              meeting: widget.meeting,
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
                  widget.meeting.title.trim() != ""
                      ? widget.meeting.title
                      : "Title: ...",
                  style: TextStyle(color: widget.textColor, fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                MeetingStatusChip(meetingStatus: widget.meeting.status),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MeetingCardDivider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isFavoriteList != null &&
                                widget.isFavoriteList == true &&
                                widget.meeting.archived)
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
                              widget.meeting.description,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
                const MeetingCardDivider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    "${tr("meeting_creation_date")}: ${widget.meeting.creationDateAtMillis.toDateTimeString()}",
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
