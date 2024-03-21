import 'dart:async';
import 'package:floor/floor.dart';
import 'package:readthevoice/data/dao/meeting_dao.dart';
import 'package:readthevoice/data/model/meeting.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part "rtv_database.g.dart";

@Database(version: 1, entities: [Meeting])
abstract class AppDatabase extends FloorDatabase
{
  // After modifying the dao, RUN "flutter packages pub run build_runner build"
  // If adding dao, modify the version
  MeetingDao get meetingDao;
}

