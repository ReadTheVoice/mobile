import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readthevoice/data/model/meeting.dart';

class MeetingField extends StatelessWidget {
  final String name;
  final String? value;

  const MeetingField({super.key, required this.name, this.value = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: tr(name),
            // icon: const FaIcon(FontAwesomeIcons.f),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primaryContainer
                )
            )
          ),
          controller: TextEditingController(text: value),
          readOnly: true,
          autofocus: true),
    );
  }
}

class MeetingStatusChip extends StatelessWidget {
  final MeetingStatus meetingStatus;

  const MeetingStatusChip({super.key, required this.meetingStatus});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        meetingStatus.title,
        style: TextStyle(color: meetingStatus.textColor),
      ),
      backgroundColor: meetingStatus.backgroundColor,
    );
  }
}

class MeetingAttributeCard extends StatelessWidget {
  final String firstName;
  final String? firstValue;
  final String secondName;
  final String? secondValue;

  const MeetingAttributeCard(
      {super.key,
      required this.firstName,
      this.firstValue = "",
      required this.secondName,
      this.secondValue = ""});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName,
                  style: const TextStyle(
                      fontSize: 15, decoration: TextDecoration.underline),
                ).tr(),
                Text(
                  firstValue ?? "",
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  secondName,
                  style: const TextStyle(
                      fontSize: 15, decoration: TextDecoration.underline),
                ).tr(),
                Text(
                  secondValue ?? "",
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            )),
      ),
    );
  }
}

class MeetingCardDivider extends StatelessWidget {
  final Color? color;

  const MeetingCardDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2,
      thickness: 1,
      color: color ?? Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }
}
