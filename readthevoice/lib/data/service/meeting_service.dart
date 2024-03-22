import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/db/rtv_database.dart';
import 'package:readthevoice/data/model/meeting.dart';

class MeetingService {
  const MeetingService();

  Future<List<Meeting>> getAllMeetings() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    return await meetingDao.findAllMeetings();
  }

  Future<List<Meeting>> getUnarchivedMeetings() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    return await meetingDao.findUnarchivedMeetings();
  }

  Future<List<Meeting>> getArchivedMeetings() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    return await meetingDao.findArchivedMeetings();
  }

  Future<List<Meeting>> getFavoriteMeetings() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    return await meetingDao.findFavoriteMeetings();
  }

  void setArchiveMeetingById(String meetingId, bool archiveMeeting) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.setArchiveMeetingById(meetingId, archiveMeeting);
  }

  void setFavoriteMeetingById(String meetingId, bool favoriteMeeting) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.setFavoriteMeetingById(meetingId, favoriteMeeting);
  }

  void insertMeeting(Meeting meeting) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.insertMeeting(meeting);
  }

  void deleteMeetingById(String meetingId) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.deleteMeeting(meetingId);
  }

  Future<int?> getMeetingCount() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    return await meetingDao.countMeetings();
  }

  Future<void> insertSampleData() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    // final int? countMeetings = await getMeetingCount();

    // int countMeeting = await getAllMeetings()
    var meetings = await getAllMeetings();
    int countMeeting = meetings.length;

    // if (countMeetings == 0) {
    if (countMeeting == 0) {
      Meeting firstMeeting = Meeting(
          "id 1", "title", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting = Meeting(
          "id 2", "title1", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting2 = Meeting(
          "id 21", "title2", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting3 = Meeting(
          "id 22", "title3", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting4 = Meeting(
          "id 23", "title4", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting5 = Meeting(
          "id 24", "title5", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting6 = Meeting(
          "id 25", "title6", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting7 = Meeting(
          "id 26", "title7", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting8 = Meeting(
          "id 27", "title8", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting9 = Meeting(
          "id 28", "title9", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting10 = Meeting(
          "id 29", "title10", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting11 = Meeting(
          "id 211", "title11", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting12 = Meeting(
          "id 212", "title12", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting13 = Meeting(
          "id 213", "title13", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting14 = Meeting(
          "id 214", "title14", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting15 = Meeting(
          "id 215", "title15", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting16 = Meeting(
          "id 216", "title16", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting17 = Meeting(
          "id 217", "title17", 17, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting18 = Meeting(
          "id 218", "title18", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting19 = Meeting(
          "id 219", "title19", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting20 = Meeting(
          "id 2222", "title20", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting21 = Meeting("id 2111", "title21", 21, 1,
          "transcription", "userEmail", "username");
      Meeting secondMeeting22 = Meeting(
          "id 2333", "title22", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting23 = Meeting(
          "id 2444", "title23", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting24 = Meeting(
          "id 2555", "title24", 1, 1, "transcription", "userEmail", "username");
      Meeting secondMeeting25 = Meeting(
          "id 2666", "title25", 1, 1, "transcription", "userEmail", "username");

      await meetingDao.insertMultipleMeetings([
        firstMeeting,
        secondMeeting,
        secondMeeting2,
        secondMeeting3,
        secondMeeting4,
        secondMeeting5,
        secondMeeting6,
        secondMeeting7,
        secondMeeting8,
        secondMeeting9,
        secondMeeting10,
        secondMeeting11,
        secondMeeting12,
        secondMeeting13,
        secondMeeting14,
        secondMeeting15,
        secondMeeting16,
        secondMeeting17,
        secondMeeting18,
        secondMeeting19,
        secondMeeting20,
        secondMeeting21,
        secondMeeting22,
        secondMeeting23,
        secondMeeting24,
        secondMeeting25
      ]);
    }
  }
}
