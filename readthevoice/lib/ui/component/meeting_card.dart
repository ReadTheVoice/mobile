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

  final Function? setFavorite;
  final Function? deleteMeeting;

  const MeetingCard(
      {super.key,
      required this.meeting,
      required this.title,
      required this.transcription,
      this.setFavorite,
      this.deleteMeeting});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.teal,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10.0),
          title: Row(
            children: [const Icon(Icons.meeting_room_outlined), Text(title)],
          ),
          subtitle: Text(transcription),
          trailing: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // meeting.favorite ? const Icon(Icons.favorite_rounded) : const Icon(Icons.favorite_border_rounded),

              meeting.favorite
                  ? IconButton(
                      icon: const Icon(Icons.favorite_rounded),
                      onPressed: setFavorite!(meeting.id),
                    )
                  : const Icon(Icons.favorite_border_rounded),
              const Icon(Icons.delete_outline_rounded),
            ],
          ),
        ));
  }
}
