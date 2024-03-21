// class ReusableButton extends StatelessWidget {
//   final String text; // Button text (property)
//   final Function onPressed; // Callback function (property)
//
//   const ReusableButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: onPressed,
//       child: Text(text),
//     );
//   }
// }
//
// ElevatedButton(
// onPressed: () => print('Clicked!'),
// child: ReusableButton(text: 'Click Me', onPressed: () => print('Clicked!')),
// ),

import 'package:flutter/material.dart';
import 'package:readthevoice/data/model/meeting.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final String title;
  final String transcription;
  final Color background = Colors.teal;
  final Color textColor = Colors.white;

  const MeetingCard({super.key, required this.meeting, required this.title, required this.transcription});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.teal,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10.0),
          title: Text(title),
          subtitle: Text(transcription),
          trailing: meeting.archived ? const Icon( Icons.unarchive_outlined ) : const Icon(Icons.archive_outlined),
        ));
  }
}



