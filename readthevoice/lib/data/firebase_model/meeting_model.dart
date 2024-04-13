import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readthevoice/data/firebase_model/user_model.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';

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
  bool allowDownload;
  String? transcription;
  String? language;
  UserModel? creatorModel;

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
      this.scheduledDate,
      this.allowDownload = false,
      this.transcription = "",
      this.language,
      this.creatorModel});

  static MeetingModel example() {
    return MeetingModel(
        id: "", createdAt: DateTime.now(), creator: "", name: "");
  }

  static MeetingModel fromFirebase(String meetingId, Map<String, dynamic> data) {
  // static Future<MeetingModel> fromFirebase(String meetingId, Map<String, dynamic> data) async {
    MeetingModel fbMeeting = MeetingModel(
        id: meetingId,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            (data['createdAt'] as Timestamp).millisecondsSinceEpoch),
        creator: data['creator'],
        name: data['name'],
        deletionDate: data['deletionDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (data['deletionDate'] as Timestamp).millisecondsSinceEpoch)
            : null,
        description: data['description'],
        endDate: data['endDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (data['endDate'] as Timestamp).millisecondsSinceEpoch)
            : null,
        isFinished: data['isFinished'],
        isTranscriptAccessibleAfter: data['isTranscriptAccessibleAfter'],
        scheduledDate: data['scheduledDate'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (data['scheduledDate'] as Timestamp).millisecondsSinceEpoch)
            : null,
        allowDownload: data["allowDownload"] ?? false,
        language: data["language"]);

    // fbMeeting.transcription =
    //     await FirebaseDatabaseService().getMeetingTranscription(meetingId);
    // fbMeeting.creatorModel =
    //     await FirebaseDatabaseService().getMeetingCreator(fbMeeting.creator);

    return fbMeeting;
  }
}

extension MeetingModelConversion on MeetingModel {
  Future<void> setTranscriptionAndCreatorModel(String meetingId) async {
    transcription =
    await FirebaseDatabaseService().getMeetingTranscription(meetingId);

    creatorModel =
    await FirebaseDatabaseService().getMeetingCreator(creator);
  }

  MeetingStatus getMeetingStatus() {
    MeetingStatus status = MeetingStatus.createdNotStarted;

    if (isFinished || endDate != null) {
      status = MeetingStatus.ended;
    } else if (scheduledDate != null &&
        (DateTime.now().isAfter(scheduledDate!))) {
      status = MeetingStatus.started;
    } else if (transcription != null && transcription!.trim().isNotEmpty) {
      status = MeetingStatus.started;
    }

    return status;
  }

  MeetingST toMeetingST(UserModel? creator) {
    String username = (creatorModel != null) ? "${creatorModel?.firstName} ${creatorModel?.lastName}" : "${creator?.firstName} ${creator?.lastName}";
    MeetingStatus status = getMeetingStatus();

    return MeetingST(
        id: id,
        userId: this.creator,
        transcription: transcription ?? "",
        userName: username,
        status: status);
  }

  Meeting toMeeting(UserModel? creator) {
    bool autoDelete = deletionDate != null;
    String username = "${creator?.firstName} ${creator?.lastName}";
    MeetingStatus status = MeetingStatus.createdNotStarted;

    if (isFinished || endDate != null) {
      status = MeetingStatus.ended;
    } else if (scheduledDate != null &&
        (DateTime.now().isAfter(scheduledDate!))) {
      status = MeetingStatus.started;
    } else if (transcription != null && transcription!.trim().isNotEmpty) {
      status = MeetingStatus.started;
    }

    return Meeting(
        id: id,
        title: name,
        creationDateAtMillis: createdAt.millisecondsSinceEpoch,
        userId: this.creator,
        autoDeletion: autoDelete,
        description: description ?? "",
        isTranscriptAccessibleAfter: isTranscriptAccessibleAfter,
        scheduledDateAtMillis: (scheduledDate != null)
            ? scheduledDate?.millisecondsSinceEpoch
            : null,
        endDateAtMillis:
            (endDate != null) ? endDate?.millisecondsSinceEpoch : null,
        autoDeletionDateAtMillis:
            autoDelete ? deletionDate?.millisecondsSinceEpoch : null,
        userName: username,
        status: status,
        allowDownload: allowDownload,
        transcription: transcription ?? "",
        language: language);
  }
}
