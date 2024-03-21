import 'package:floor/floor.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/model/meeting.dart';

// Data Access Object
@dao
abstract class MeetingDao {
  // @Query('SELECT * FROM meeting')
  // @Query('SELECT * FROM $MEETING_TABLE_NAME')
  @Query('SELECT * FROM $MEETING_TABLE_NAME WHERE archived = false order by creationDateAtMillis desc')
  Future<List<Meeting>> findAllMeeting();

  @Query('SELECT * FROM $MEETING_TABLE_NAME WHERE archived = true order by creationDateAtMillis desc')
  Future<List<Meeting>> findAllArchivedMeeting();

  // @Query('SELECT title FROM meeting')
  @Query('SELECT title FROM $MEETING_TABLE_NAME')
  Stream<List<String>> findAllMeetingTitle();

  // @Query('SELECT * FROM meeting WHERE id = :id')
  @Query('SELECT * FROM $MEETING_TABLE_NAME WHERE id = :id')  // 190262ff
  Stream<Meeting?> findMeetingById(String id);

  // @Query('SELECT * FROM meeting WHERE id = :id')
  @Query('UPDATE $MEETING_TABLE_NAME SET archived = :archived WHERE id = :id')  // 190262ff
  Future<void> archiveMeetingById(String id, bool archived);

  @insert
  Future<void> insertMeeting(Meeting meeting);

  @insert
  Future<void> insertMultipleMeetings(List<Meeting> meetings);

  // @Query("delete from meeting where id = :id")
  @Query("DELETE FROM $MEETING_TABLE_NAME WHERE id = :id")
  Future<void> deleteMeeting(String id);

  @delete
  Future<int> deleteAllMeeting(List<Meeting> list);
}

/*
Run flutter packages pub run build_runner build to generate the code needed for
interacting with the database based on your entities and DAOs.
This creates a new file like $FloorAppDatabase.dart.
*/

/*
final database = $FloorAppDatabase.databaseBuilder('my_database.db').build();

final userDao = database.userDao;
await userDao.insertUser(User('John Doe', 30));
final users = await userDao.getAllUsers();

  @Query('SELECT * FROM todo')
  Future<List<Todo>> findAllTodo();

  @Query('Select * from todo order by id desc limit 1')
  Future<Todo> getMaxTodo();

  @Query('SELECT * FROM todo order by id desc')
  Stream<List<Todo>> fetchStreamData();

  @insert
  Future<void> insertTodo(Todo todo);

  @insert
  Future<List<int>> insertAllTodo(List<Todo> todo);

  @Query("delete from todo where id = :id")
  Future<void> deleteTodo(int id);

  @delete
  Future<int> deleteAll(List<Todo> list);
 */

