// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtv_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MeetingDao? _meetingDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `meeting` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `status` INTEGER NOT NULL, `creationDateAtMillis` INTEGER NOT NULL, `autoDeletion` INTEGER, `autoDeletionDateAtMillis` INTEGER, `transcription` TEXT NOT NULL, `userEmail` TEXT NOT NULL, `username` TEXT, `favorite` INTEGER NOT NULL, `archived` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MeetingDao get meetingDao {
    return _meetingDaoInstance ??= _$MeetingDao(database, changeListener);
  }
}

class _$MeetingDao extends MeetingDao {
  _$MeetingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _meetingInsertionAdapter = InsertionAdapter(
            database,
            'meeting',
            (Meeting item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'status': item.status.index,
                  'creationDateAtMillis': item.creationDateAtMillis,
                  'autoDeletion': item.autoDeletion == null
                      ? null
                      : (item.autoDeletion! ? 1 : 0),
                  'autoDeletionDateAtMillis': item.autoDeletionDateAtMillis,
                  'transcription': item.transcription,
                  'userEmail': item.userEmail,
                  'username': item.username,
                  'favorite': item.favorite ? 1 : 0,
                  'archived': item.archived ? 1 : 0
                }),
        _meetingDeletionAdapter = DeletionAdapter(
            database,
            'meeting',
            ['id'],
            (Meeting item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'status': item.status.index,
                  'creationDateAtMillis': item.creationDateAtMillis,
                  'autoDeletion': item.autoDeletion == null
                      ? null
                      : (item.autoDeletion! ? 1 : 0),
                  'autoDeletionDateAtMillis': item.autoDeletionDateAtMillis,
                  'transcription': item.transcription,
                  'userEmail': item.userEmail,
                  'username': item.username,
                  'favorite': item.favorite ? 1 : 0,
                  'archived': item.archived ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Meeting> _meetingInsertionAdapter;

  final DeletionAdapter<Meeting> _meetingDeletionAdapter;

  @override
  Future<List<Meeting>> findAllMeetings() async {
    return _queryAdapter.queryList(
        'SELECT * FROM meeting order by creationDateAtMillis desc',
        mapper: (Map<String, Object?> row) => Meeting(
            row['id'] as String,
            row['title'] as String,
            row['creationDateAtMillis'] as int,
            row['autoDeletionDateAtMillis'] as int?,
            row['transcription'] as String,
            row['userEmail'] as String,
            row['username'] as String?,
            MeetingStatus.values[row['status'] as int],
            row['autoDeletion'] == null
                ? null
                : (row['autoDeletion'] as int) != 0,
            (row['favorite'] as int) != 0,
            (row['archived'] as int) != 0));
  }

  @override
  Future<List<Meeting>> findUnarchivedMeetings() async {
    return _queryAdapter.queryList(
        'SELECT * FROM meeting WHERE archived = false order by creationDateAtMillis desc',
        mapper: (Map<String, Object?> row) => Meeting(
            row['id'] as String,
            row['title'] as String,
            row['creationDateAtMillis'] as int,
            row['autoDeletionDateAtMillis'] as int?,
            row['transcription'] as String,
            row['userEmail'] as String,
            row['username'] as String?,
            MeetingStatus.values[row['status'] as int],
            row['autoDeletion'] == null
                ? null
                : (row['autoDeletion'] as int) != 0,
            (row['favorite'] as int) != 0,
            (row['archived'] as int) != 0));
  }

  @override
  Future<List<Meeting>> findArchivedMeetings() async {
    return _queryAdapter.queryList(
        'SELECT * FROM meeting WHERE archived = true order by creationDateAtMillis desc',
        mapper: (Map<String, Object?> row) => Meeting(
            row['id'] as String,
            row['title'] as String,
            row['creationDateAtMillis'] as int,
            row['autoDeletionDateAtMillis'] as int?,
            row['transcription'] as String,
            row['userEmail'] as String,
            row['username'] as String?,
            MeetingStatus.values[row['status'] as int],
            row['autoDeletion'] == null
                ? null
                : (row['autoDeletion'] as int) != 0,
            (row['favorite'] as int) != 0,
            (row['archived'] as int) != 0));
  }

  @override
  Future<List<Meeting>> findFavoriteMeetings() async {
    return _queryAdapter.queryList(
        'SELECT * FROM meeting WHERE favorite = true order by creationDateAtMillis desc',
        mapper: (Map<String, Object?> row) => Meeting(
            row['id'] as String,
            row['title'] as String,
            row['creationDateAtMillis'] as int,
            row['autoDeletionDateAtMillis'] as int?,
            row['transcription'] as String,
            row['userEmail'] as String,
            row['username'] as String?,
            MeetingStatus.values[row['status'] as int],
            row['autoDeletion'] == null
                ? null
                : (row['autoDeletion'] as int) != 0,
            (row['favorite'] as int) != 0,
            (row['archived'] as int) != 0));
  }

  @override
  Stream<List<String>> findMeetingTitles() {
    return _queryAdapter.queryListStream('SELECT title FROM meeting',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'meeting',
        isView: false);
  }

  @override
  Future<Meeting?> findMeetingById(String id) async {
    return _queryAdapter.query('SELECT * FROM meeting WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Meeting(
            row['id'] as String,
            row['title'] as String,
            row['creationDateAtMillis'] as int,
            row['autoDeletionDateAtMillis'] as int?,
            row['transcription'] as String,
            row['userEmail'] as String,
            row['username'] as String?,
            MeetingStatus.values[row['status'] as int],
            row['autoDeletion'] == null
                ? null
                : (row['autoDeletion'] as int) != 0,
            (row['favorite'] as int) != 0,
            (row['archived'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> setArchiveMeetingById(
    String id,
    bool archived,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE meeting SET archived = ?2 WHERE id = ?1',
        arguments: [id, archived ? 1 : 0]);
  }

  @override
  Future<void> setFavoriteMeetingById(
    String id,
    bool favorite,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE meeting SET favorite = ?2 WHERE id = ?1',
        arguments: [id, favorite ? 1 : 0]);
  }

  @override
  Future<void> deleteMeeting(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM meeting WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertMeeting(Meeting meeting) async {
    await _meetingInsertionAdapter.insert(meeting, OnConflictStrategy.rollback);
  }

  @override
  Future<void> insertMultipleMeetings(List<Meeting> meetings) async {
    await _meetingInsertionAdapter.insertList(
        meetings, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAllMeeting(List<Meeting> list) async {
    await _meetingDeletionAdapter.deleteList(list);
  }
}
