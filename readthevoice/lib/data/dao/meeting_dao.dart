import 'package:floor/floor.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/model/meeting.dart';

// Data Access Object
@dao
abstract class MeetingDao {
  // @Query('SELECT * FROM meeting')
  // @Query('SELECT * FROM todo order by id desc')
  @Query('SELECT * FROM $MEETING_TABLE_NAME order by id desc')
  Future<List<Meeting>> findAllMeeting();

  // @Query('SELECT title FROM meeting')
  @Query('SELECT title FROM $MEETING_TABLE_NAME')
  Stream<List<String>> findAllMeetingTitle();

  // @Query('SELECT * FROM meeting WHERE id = :id')
  @Query('SELECT * FROM $MEETING_TABLE_NAME WHERE id = :id')
  Stream<Meeting?> findMeetingById(String id);

  @insert
  Future<void> insertMeeting(Meeting meeting);

  // @Query("delete from meeting where id = :id")
  @Query("delete from $MEETING_TABLE_NAME where id = :id")
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

