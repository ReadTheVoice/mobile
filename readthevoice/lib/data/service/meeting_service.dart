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

  Future<void> setArchiveMeetingById(String meetingId, bool archiveMeeting) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.setArchiveMeetingById(meetingId, archiveMeeting);
  }

  Future<void> setFavoriteMeetingById(String meetingId, bool favoriteMeeting) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.setFavoriteMeetingById(meetingId, favoriteMeeting);
  }

  Future<void> insertMeeting(Meeting meeting) async {
    Meeting? meetingToAdd = await getMeetingById(meeting.id);

    if (meetingToAdd == null) {
      final database = await $FloorAppDatabase
          .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
          .build();

      final meetingDao = database.meetingDao;
      await meetingDao.insertMeeting(meeting);
    }
  }

  Future<void> deleteMeetingById(String meetingId) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.deleteMeeting(meetingId);
  }

  /// Get a specific meeting using its id
  ///
  /// @param meetingId Specifies the id of the meeting
  /// @return The meeting or null if not found
  Future<Meeting?> getMeetingById(String meetingId) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;

    return await meetingDao.findMeetingById(meetingId);
  }

  Future<void> insertSampleData() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;

    var meetings = await getAllMeetings();
    int countMeeting = meetings.length;

    if(countMeeting == 0) {
      await meetingDao.insertMultipleMeetings([
        Meeting.example("night"),
        Meeting.example("id 1"),
        Meeting.example("id 2"),
        Meeting.example("id 3"),
        Meeting.example("id 4"),
        Meeting.example("id 5"),
      ]);
    }
  }

  Future<void> updateMeeting(Meeting meeting) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.updateMeeting(meeting);
  }
}
