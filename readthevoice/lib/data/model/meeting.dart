import 'package:floor/floor.dart';
import 'package:readthevoice/data/constants.dart';

enum MeetingStatus {
  createdNotStarted,
  started,
  ended;

  String get getStatusTitle {
    switch (this) {
      case MeetingStatus.createdNotStarted:
        return "Created";  // Has not yet started
      case MeetingStatus.started:
        return "Started";
      case MeetingStatus.ended:
        return "Ended";
      default:
        return "None";
    }
  }
}

/*

createdAt 12 March 2024 at 17:31:13 UTC+1
(timestamp)

creator "cxXhggjFnBgROGkVrlq0JidhxI52"
(string)

deletionDate 20 April 2024 at 13:11:00 UTC+2
(timestamp)

description "Ma belle description"
(string)

endDate null
(null)

isFinished false
(Boolean)

isTranscriptAccessibleAfter true
(Boolean)

name "Sharonn"
(string)

scheduledDate 12 March 2024 at 17:30:00 UTC+1
 */

@Entity(tableName: MEETING_TABLE_NAME)
class Meeting {
  @PrimaryKey()
  final String id;

  final String title;
  final MeetingStatus status;

  // final DateTime creationDate;
  final int creationDateAtMillis;

  final bool? autoDeletion;

  // final DateTime? autoDeletionDate;
  final int? autoDeletionDateAtMillis;

  final String transcription;
  final String userEmail;
  final String? username;
  bool favorite;
  bool archived;

  // Meeting();
  /*
  User(this.name, DateTime createdAt)
      : createdAtMillis = createdAt.millisecondsSinceEpoch;

      autoDeletionDateAtMillis = autoDeletionDate.millisecondsSinceEpoch;
   */
  Meeting(this.id, this.title, this.creationDateAtMillis, this.autoDeletionDateAtMillis,
      this.transcription, this.userEmail, this.username,
      [this.status = MeetingStatus.createdNotStarted,
      this.autoDeletion = false,
      this.favorite = false,
      this.archived = false]);

  /*
    // Convert back to DateTime in your app logic
    final user = users.first;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(user.createdAtMillis);
    autoDeletionDate = DateTime.fromMillisecondsSinceEpoch(user.autoDeletionDateAtMillis);
   */
}

// Create a converter class
// class UserTypeConverter extends TypeConverter<UserType, String> {
//   @override
//   UserType convertFromDatabase(String source) {
//     return UserType.values.firstWhere((value) => value.name == source);
//   }
//
//   @override
//   String convertToDatabase(UserType source) => source.name;
// }

// final User user = User('John Doe', DateTime.now(), UserType.admin);
//
// @entity
// class User {
//   // ... other fields
//
//   @TypeConverter()
//   final UserType type;
//
//   User(this.name, this.createdAt, this.type);
// }

// Entity
// @entity
// class User {
//   // ... other fields
//
//   final int createdAtMillis;
//
//   User(this.name, DateTime createdAt)
//       : createdAtMillis = createdAt.millisecondsSinceEpoch;
// }
//
// // DAO (Conversion on insertion)
// @insert
// Future<void> insertUser(User user) async {
//   await database.userDao.insertUser(user.copyWith(
//       createdAtMillis: user.createdAt.millisecondsSinceEpoch));
// }
//
// // DAO (Conversion on retrieval)
// @query('SELECT * FROM User')
// Future<List<User>> getAllUsers();
//
// // Convert back to DateTime in your app logic
// final user = users.first;
// final dateTime = DateTime.fromMillisecondsSinceEpoch(user.createdAtMillis);



// flutter packages pub run build_runner build
// flutter packages pub run build_runner watch
