import 'package:readthevoice/data/firebase_model/user_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/utils/utils.dart';

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

extension on MeetingModel {
  Meeting toMeeting(MeetingModel fbMeeting, UserModel? creator) {
    bool autoDelete = fbMeeting.deletionDate != null;
    String username = "${creator?.firstName} ${creator?.lastName}";
    MeetingStatus status = MeetingStatus.createdNotStarted;

    if (fbMeeting.isFinished) {
      status = MeetingStatus.ended;
    } else if (fbMeeting.scheduledDate != null &&
        (DateTime.now().isAfter(fbMeeting.scheduledDate!))) {
      status = MeetingStatus.started;
    }

    return Meeting(
        id: fbMeeting.id,
        title: fbMeeting.name,
        creationDateAtMillis: fromDateTimeToMillis(fbMeeting.createdAt),
        userId: fbMeeting.creator,
        autoDeletion: autoDelete,
        scheduledDateAtMillis: (fbMeeting.scheduledDate != null) ? fromDateTimeToMillis(fbMeeting.scheduledDate!) : null,
        autoDeletionDateAtMillis:
            autoDelete ? fromDateTimeToMillis(fbMeeting.deletionDate!) : null,
        userName: username,
        status: status);
  }
}
