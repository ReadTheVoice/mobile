import 'package:readthevoice/data/model/meeting.dart';
import 'package:readthevoice/data/service/firebase_database_service.dart';
import 'package:readthevoice/data/service/meeting_service.dart';

enum AppThemeMode { light, dark }

enum AvailableScreens {
  main,
  home,
  favoriteMeetings,
  archivedMeetings,
  settings,
  aboutUs,
  meeting,
  transcriptionStream
}

extension DateTimeStringConversion on int {
  String toDateTimeString() {
    // TODO Proceed with correct manipulations
    return DateTime.fromMillisecondsSinceEpoch(this).toString();
  }
}

Future<void> refreshMeetingList() async {
  MeetingService meetingService = const MeetingService();
  FirebaseDatabaseService firebaseService = FirebaseDatabaseService();

  List<Meeting> localMeetings = await meetingService.getAllMeetings();

  // if (localMeetings.isNotEmpty) {
  //   for (var existing in localMeetings) {
  //     // get fb entity
  //     Meeting? meeting = await firebaseService.getMeeting(existing.id);
  //
  //     if (meeting != null) {
  //       meeting.favorite = existing.favorite;
  //       meeting.archived = existing.archived;
  //
  //       if (meeting.endDateAtMillis != null) {
  //         meeting.status = MeetingStatus.ended;
  //       }
  //
  //       await meetingService.updateMeeting(meeting);
  //     } else {
  //       await meetingService.deleteMeetingById(existing.id);
  //     }
  //   }
  // }
}
