import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'package:floor/floor.dart';

import 'package:noots_app/data/notes_dao.dart';
import '../model/notes.dart';

part 'notes_database.g.dart';

@Database(version: 6, entities: [Notes])
abstract class AppDatabase extends FloorDatabase {
  NotesDao get notesDao;
}
