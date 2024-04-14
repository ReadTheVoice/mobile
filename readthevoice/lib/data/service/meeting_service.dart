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
    return await meetingDao.findAllMeetings() ?? List.empty();
  }

  Future<List<Meeting>> getUnarchivedMeetings() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    return await meetingDao.findUnarchivedMeetings() ?? List.empty();
  }

  Future<List<Meeting>> getArchivedMeetings() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    return await meetingDao.findArchivedMeetings() ?? List.empty();
  }

  Future<List<Meeting>> getFavoriteMeetings() async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    return await meetingDao.findFavoriteMeetings() ?? List.empty();
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

  Future<Meeting?> getMeetingById(String meetingId) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;

    return await meetingDao.findMeetingById(meetingId);
  }

  Future<void> updateMeeting(Meeting meeting) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    await meetingDao.updateMeeting(meeting);
  }

  Future<void> updateMeetingTranscription(String meetingId, String? transcription) async {
    final database = await $FloorAppDatabase
        .databaseBuilder('$READ_THE_VOICE_DATABASE_NAME.db')
        .build();

    final meetingDao = database.meetingDao;
    if(transcription != null && transcription.isNotEmpty) {
      await meetingDao.updateTranscriptionMeetingById(meetingId, transcription);
    }
  }
}
