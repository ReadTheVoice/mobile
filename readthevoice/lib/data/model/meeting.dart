import 'package:easy_localization/easy_localization.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/constants.dart';

// flutter packages pub run build_runner build
// dart run build_runner build
enum MeetingStatus {
  createdNotStarted,
  started,
  ended;

  String get title {
    switch (this) {
      case MeetingStatus.createdNotStarted:
        return tr("meeting_status_created"); // Has not yet started
      case MeetingStatus.started:
        return tr("meeting_status_started");
      case MeetingStatus.ended:
        return tr("meeting_status_ended");
      default:
        return "None";
    }
  }
  
  Color get backgroundColor {
    switch (this) {
      case MeetingStatus.createdNotStarted:
        return Colors.grey; // Has not yet started
      case MeetingStatus.started:
        return Colors.deepPurpleAccent;
      case MeetingStatus.ended:
        return Colors.redAccent;
      default:
        return Colors.transparent;
    }
  }

  Color get textColor {
    switch (this) {
      case MeetingStatus.createdNotStarted:
        return Colors.black; // Has not yet started
      case MeetingStatus.started:
        return Colors.white;
      case MeetingStatus.ended:
        return Colors.white;
      default:
        return Colors.white;
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
  int? endDateAtMillis;

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
      this.endDateAtMillis,
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
