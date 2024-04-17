import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/ui/component/meeting_basic_components.dart';

class MeetingDetailsScreen extends StatelessWidget {
  final Function() onClose;

  final MeetingModel meetingModel;
  final Meeting meeting;

  const MeetingDetailsScreen(
      {super.key,
      required this.onClose,
      required this.meetingModel,
      required this.meeting});

  @override
  Widget build(BuildContext context) {
    bool autoDeletion = meetingModel.deletionDate != null;

    return SafeArea(
        child: Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(children: [
            Center(
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Text(
                            "Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          if (meeting.archived)
                            Tooltip(
                              message: tr("archived_button_tooltip"),
                              showDuration: const Duration(seconds: 3),
                              child: const FaIcon(FontAwesomeIcons.snowflake),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (meeting.favorite)
                            Tooltip(
                              message: tr("favorite_button_tooltip"),
                              showDuration: const Duration(seconds: 3),
                              child: const FaIcon(FontAwesomeIcons.solidHeart),
                            )
                        ],
                      ),
                    ),
                  ),
                  MeetingField(name: "meeting_title", value: meetingModel.name),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MeetingAttributeCard(
                        firstName: "meeting_status",
                        firstValue: meeting.status.title,
                        secondName: "meeting_schedule_date",
                        secondValue: meetingModel.scheduledDate?.toString(),
                      ),
                      MeetingAttributeCard(
                        firstName: "meeting_creator",
                        firstValue: meeting.userName!.trim().isNotEmpty
                            ? meeting.userName
                            : "${meetingModel.creatorModel?.firstName} ${meetingModel.creatorModel?.lastName}",
                        secondName: "meeting_creation_date",
                        secondValue: meetingModel.createdAt.toString(),
                      ),
                    ],
                  ),
                  MeetingField(
                      name: "meeting_description",
                      value: meetingModel.description),
                  MeetingField(
                      name: "meeting_end_date",
                      value: meetingModel.endDate.toString()),
                  if (autoDeletion == true)
                    MeetingField(
                        name: "meeting_auto_delete_date",
                        value: meetingModel.deletionDate.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "ID: ${meetingModel.id}",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: FloatingActionButton(
                mini: true,
                onPressed: onClose,
                backgroundColor: Colors.grey.shade800,
                tooltip: tr("close_details_view"),
                child: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: Colors.white,
                ),
              ),
            )
          ]),
        ),
      ),
    ));
  }
}
