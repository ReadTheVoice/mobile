import 'package:floor/floor.dart';
import 'package:readthevoice/data/constants.dart';

// flutter packages pub run build_runner build
// dart run build_runner build
enum MeetingStatus {
  createdNotStarted,
  started,
  ended;

  String get getStatusTitle {
    switch (this) {
      case MeetingStatus.createdNotStarted:
        return "Created"; // Has not yet started
      case MeetingStatus.started:
        return "Started";
      case MeetingStatus.ended:
        return "Ended";
      default:
        return "None";
    }
  }
}

@Entity(tableName: MEETING_TABLE_NAME)
class Meeting {
  @PrimaryKey()
  final String id;

  final int creationDateAtMillis;
  final String title;
  final String userId;
  final String? userName;

  String? description;
  bool? autoDeletion;
  int? autoDeletionDateAtMillis;
  int? scheduledDateAtMillis;
  String? transcriptionId;

  MeetingStatus status;
  String transcription;
  bool favorite;
  bool archived;

  Meeting(
      {required this.id,
      required this.title,
      required this.creationDateAtMillis,
      required this.userId,
      this.autoDeletionDateAtMillis,
      this.scheduledDateAtMillis,
      this.transcription = "",
      this.transcriptionId,
      this.userName,
      this.status = MeetingStatus.createdNotStarted,
      this.autoDeletion = false,
      this.favorite = false,
      this.archived = false});

  static Meeting example(String id) {
    return Meeting(id: id, title: "", creationDateAtMillis: DateTime.now().millisecondsSinceEpoch, userId: "");
  }
}
