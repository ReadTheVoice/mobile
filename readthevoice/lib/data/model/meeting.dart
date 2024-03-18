import 'package:floor/floor.dart';

enum MeetingStatus {
  createdNotStarted,
  started,
  ended;

  String get getStatusTitle {
    switch(this) {
      case MeetingStatus.createdNotStarted:
        return "yoyo";
      case MeetingStatus.started:
        return "started";
      case MeetingStatus.ended:
        return "ended";
      default:
        return "started";
    }
  }
}

@entity
class Meeting {
  @primaryKey
  final String id;

  final String title;
  final MeetingStatus status;
  final DateTime creationDate;
  final bool? autoDeletion;
  final DateTime? autoDeletionDate;
  final String transcription;
  final String userEmail;
  final String? username;
  final bool favorite;
  final bool archived;

  // Meeting();
  Meeting(this.id, this.title, this.creationDate, this.autoDeletionDate, this.transcription, this.userEmail, this.username, [this.status = MeetingStatus.createdNotStarted, this.autoDeletion = false, this.favorite = false, this.archived = false]);
}
