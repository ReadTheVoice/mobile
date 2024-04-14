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

  static MeetingModel fromFirebase(
      String meetingId, Map<String, dynamic> data) {
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

    fbMeeting.setTranscriptionAndCreatorModel(meetingId, fbMeeting);

    return fbMeeting;
  }
}

extension MeetingModelConversion on MeetingModel {
  Future<void> setTranscriptionAndCreatorModel(String meetingId, MeetingModel model) async {
    FirebaseDatabaseService().getMeetingTranscription(meetingId).then((value) {
      model.transcription = value;
    });

    FirebaseDatabaseService().getMeetingCreator(creator).then((value) {
      model.creatorModel = value;
    });
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

  Meeting toMeeting() {
    String username = "${creatorModel?.firstName} ${creatorModel?.lastName}";
    MeetingStatus status = getMeetingStatus();

    return Meeting(
        id: id,
        userId: creator,
        transcription: transcription ?? "",
        userName: username,
        status: status);
  }
}
