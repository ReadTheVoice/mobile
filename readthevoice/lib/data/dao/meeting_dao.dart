import 'package:floor/floor.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/model/meeting.dart';

// Data Access Object
@dao
abstract class MeetingDao {
  @Query('SELECT * FROM $MEETING_TABLE_NAME')
  Future<List<Meeting>?> findAllMeetings();

  // @Query("SELECT * FROM $MEETING_TABLE_NAME WHERE archived = ${false}")
  @Query("SELECT * FROM $MEETING_TABLE_NAME WHERE archived = 0")
  Future<List<Meeting>?> findUnarchivedMeetings();

  // @Query("SELECT * FROM $MEETING_TABLE_NAME WHERE archived = ${true}")
  @Query("SELECT * FROM $MEETING_TABLE_NAME WHERE archived = 1")
  Future<List<Meeting>?> findArchivedMeetings();

  // @Query("SELECT * FROM $MEETING_TABLE_NAME WHERE favorite = ${true}")
  @Query("SELECT * FROM $MEETING_TABLE_NAME WHERE favorite = 1")
  Future<List<Meeting>?> findFavoriteMeetings();

  @Query('SELECT title FROM $MEETING_TABLE_NAME')
  Stream<List<String>?> findMeetingTitles();

  @Query('SELECT * FROM $MEETING_TABLE_NAME WHERE id = :id')
  Future<Meeting?> findMeetingById(String id);

  // Stream<Meeting?> findMeetingById(String id);

  @Query('UPDATE $MEETING_TABLE_NAME SET archived = :archived WHERE id = :id')
  Future<void> setArchiveMeetingById(String id, bool archived);

  @Query('UPDATE $MEETING_TABLE_NAME SET favorite = :favorite WHERE id = :id')
  Future<void> setFavoriteMeetingById(String id, bool favorite);

  @Query(
      'UPDATE $MEETING_TABLE_NAME SET transcription = :transcription WHERE id = :id')
  Future<void> updateTranscriptionMeetingById(String id, String transcription);

  // @Insert(onConflict: OnConflictStrategy.rollback)
  @insert
  Future<void> insertMeeting(Meeting meeting);

  @insert
  Future<void> insertMultipleMeetings(List<Meeting> meetings);

  @update
  Future<void> updateMeeting(Meeting meeting);

  @Query("DELETE FROM $MEETING_TABLE_NAME WHERE id = :id")
  Future<int?> deleteMeeting(String id);

  @delete
  Future<int> deleteSingleMeeting(Meeting meeting);

  @delete
  Future<void> deleteAllMeeting(List<Meeting> list);
}
