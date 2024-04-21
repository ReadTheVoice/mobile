import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/meeting_service.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';
import 'package:readthevoice/ui/helper/display_toast_helper.dart';
import 'package:readthevoice/ui/screen/meeting_screen.dart';

class MeetingCard extends StatefulWidget {
  final MeetingModel meetingModel;

  final Color? background;
  final Color? textColor;

  final bool? isFavoriteList;

  final Function? favoriteFunction;
  final Function? deleteFunction;

  const MeetingCard({
    super.key,
    required this.meetingModel,
    this.isFavoriteList,
    this.favoriteFunction,
    this.deleteFunction,
    this.background,
    this.textColor = Colors.white,
  });

  @override
  State<MeetingCard> createState() => _MeetingCardState();
}

class _MeetingCardState extends State<MeetingCard> {
  final MeetingService meetingService = const MeetingService();
  late Meeting? currentMeeting = null;

  Future<void> initializeAttributes() async {
    var existing = await meetingService.getMeetingById(widget.meetingModel.id);
    if (existing == null) {
      Meeting inserting = widget.meetingModel.toMeeting();
      await meetingService.insertMeeting(inserting);
      currentMeeting =
          (await meetingService.getMeetingById(widget.meetingModel.id))!;
    } else {
      currentMeeting = existing;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeAttributes();
  }

  void _showConfirmationDialog() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: (!isDarkMode)
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        title: Text('deletion_confirmation_title',
                style: TextStyle(
                    color: (!isDarkMode)
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null))
            .tr(),
        content: Text('confirmation_message_text',
                style: TextStyle(
                    color: (!isDarkMode)
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null))
            .tr(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('cancel', style: TextStyle(fontSize: 20)).tr(),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('confirm', style: TextStyle(fontSize: 20)).tr(),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed ?? false) {
        bool isDeleted =
            await meetingService.deleteMeetingById(widget.meetingModel.id);

        print("${"isDeleted => ".toUpperCase()}$isDeleted");

        if (isDeleted) {
          if (widget.deleteFunction != null) {
            widget.deleteFunction!(widget.meetingModel.id);
          }
        } else {
          setState(() {
            showSuccessfulToast(context, "successful_deletion");
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingScreen(
              meetingModelId: widget.meetingModel.id,
              meetingModelName: widget.meetingModel.name,
              meetingModelAllowDownload: widget.meetingModel.allowDownload,
              meetingModelTranscription:
                  widget.meetingModel.transcription ?? "",
              meetingModelStatus: widget.meetingModel.getMeetingStatus(),
            ),
          ),
        );
      },
      child: Card(
          color: isDarkMode
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.primary,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.meetingModel.name.trim() != ""
                      ? widget.meetingModel.name
                      : "${tr("meeting_title")}: ...",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                MeetingStatusChip(
                    meetingStatus: widget.meetingModel.getMeetingStatus()),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isFavoriteList != null &&
                                    widget.isFavoriteList == true &&
                                    currentMeeting != null
                                ? currentMeeting!.archived
                                : false)
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.snowflake,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
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
                                            .onSurface),
                                  ).tr()
                                ],
                              ),
                            Text(
                              (widget.meetingModel.description ?? ""),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (currentMeeting != null) {
                                  bool fav = !currentMeeting!.favorite;

                                  currentMeeting!.favorite = fav;
                                  meetingService.setFavoriteMeetingById(
                                      widget.meetingModel.id, fav);

                                  if (widget.favoriteFunction != null) {
                                    widget.favoriteFunction!(
                                        widget.meetingModel.id);
                                  }
                                }
                              });
                            },
                            icon: Icon(
                              (currentMeeting != null
                                      ? currentMeeting!.favorite
                                      : false)
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                        IconButton(
                            onPressed: _showConfirmationDialog,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Theme.of(context).colorScheme.onSurface,
                            ))
                      ],
                    ),
                  ],
                ),
                const MeetingCardDivider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    "${tr("meeting_creation_date")}: ${widget.meetingModel.createdAt.toString()}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
