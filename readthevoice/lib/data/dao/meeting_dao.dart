// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:readthevoice/data/model/meeting.dart';

@dao
abstract class MeetingDao {
  @Query('SELECT * FROM meeting')
  Future<List<Meeting>> findAllMeeting();

  @Query('SELECT title FROM meeting')
  Stream<List<String>> findAllMeetingTitle();

  @Query('SELECT * FROM meeting WHERE id = :id')
  Stream<Meeting?> findMeetingById(String id);

  @insert
  Future<void> insertMeeting(Meeting meeting);

  @delete
  Future<bool> deleteMeeting(String id);
}