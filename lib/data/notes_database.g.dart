// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_database.dart';

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

  NotesDao? _notesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
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
            'CREATE TABLE IF NOT EXISTS `Notes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `dateAdded` TEXT NOT NULL, `lastUpdate` TEXT, `category` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NotesDao get notesDao {
    return _notesDaoInstance ??= _$NotesDao(database, changeListener);
  }
}

class _$NotesDao extends NotesDao {
  _$NotesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _notesInsertionAdapter = InsertionAdapter(
            database,
            'Notes',
            (Notes item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'dateAdded': item.dateAdded,
                  'lastUpdate': item.lastUpdate,
                  'category': item.category
                }),
        _notesUpdateAdapter = UpdateAdapter(
            database,
            'Notes',
            ['id'],
            (Notes item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'dateAdded': item.dateAdded,
                  'lastUpdate': item.lastUpdate,
                  'category': item.category
                }),
        _notesDeletionAdapter = DeletionAdapter(
            database,
            'Notes',
            ['id'],
            (Notes item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'content': item.content,
                  'dateAdded': item.dateAdded,
                  'lastUpdate': item.lastUpdate,
                  'category': item.category
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Notes> _notesInsertionAdapter;

  final UpdateAdapter<Notes> _notesUpdateAdapter;

  final DeletionAdapter<Notes> _notesDeletionAdapter;

  @override
  Future<List<Notes>> getAllNotes() async {
    return _queryAdapter.queryList(
        'select * from notes order by dateAdded desc',
        mapper: (Map<String, Object?> row) => Notes(
            row['id'] as int?,
            row['title'] as String,
            row['dateAdded'] as String,
            row['content'] as String,
            row['lastUpdate'] as String?,
            row['category'] as String?));
  }

  @override
  Future<Notes?> selectNote(int id) async {
    return _queryAdapter.query('select * from notes where id = ?1',
        mapper: (Map<String, Object?> row) => Notes(
            row['id'] as int?,
            row['title'] as String,
            row['dateAdded'] as String,
            row['content'] as String,
            row['lastUpdate'] as String?,
            row['category'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> insertNotes(Notes notes) async {
    await _notesInsertionAdapter.insert(notes, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateNotes(Notes notes) async {
    await _notesUpdateAdapter.update(notes, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteNotes(Notes notes) async {
    await _notesDeletionAdapter.delete(notes);
  }
}
