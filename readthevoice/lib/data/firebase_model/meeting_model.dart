import 'package:readthevoice/data/firebase_model/user_model.dart';
import 'package:readthevoice/data/model/meeting.dart';

class MeetingModel {
  final String id;
  final DateTime createdAt;
  final String creator;
  String name;
  DateTime? deletionDate;
  String? description;
  DateTime? endDate;
  bool isFinished;
  bool isTranscriptAccessibleAfter;
  DateTime? scheduledDate;

  MeetingModel(
      {required this.id,
      required this.createdAt,
      required this.creator,
      required this.name,
      this.deletionDate,
      this.description,
      this.endDate,
      this.isFinished = false,
      this.isTranscriptAccessibleAfter = true,
      this.scheduledDate});

  static MeetingModel example() {
    return MeetingModel(
        id: "", createdAt: DateTime.now(), creator: "", name: "");
  }
}

extension MeetingModelConversion on MeetingModel {
  Meeting toMeeting(UserModel? creator) {
    bool autoDelete = deletionDate != null;
    String username = "${creator?.firstName} ${creator?.lastName}";
    MeetingStatus status = MeetingStatus.createdNotStarted;

    if (isFinished || endDate != null) {
      status = MeetingStatus.ended;
    } else if (scheduledDate != null &&
        (DateTime.now().isAfter(scheduledDate!))) {
      status = MeetingStatus.started;
    }

    return Meeting(
        id: id,
        title: name,
        creationDateAtMillis: createdAt.millisecondsSinceEpoch,
        userId: this.creator,
        autoDeletion: autoDelete,
        scheduledDateAtMillis: (scheduledDate != null)
            ? scheduledDate?.millisecondsSinceEpoch
            : null,
        endDateAtMillis:
            (endDate != null) ? endDate?.millisecondsSinceEpoch : null,
        autoDeletionDateAtMillis:
            autoDelete ? deletionDate?.millisecondsSinceEpoch : null,
        userName: username,
        status: status);
  }
}
