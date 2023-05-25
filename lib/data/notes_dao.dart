import 'package:floor/floor.dart';

import '../model/notes.dart';

@dao
abstract class NotesDao {
  @Query('select * from notes order by dateAdded desc')
  Future<List<Notes>> getAllNotes();

  @Query('select * from notes where id = :id')
  Future<Notes?> selectNote(int id);

  @insert
  Future<void> insertNotes(Notes notes);

  @delete
  Future<void> deleteNotes(Notes notes);

  @Query('DELETE FROM notes WHERE id = :idnotes')
  Future<void> deleteById(int idnotes);

  @update
  Future<void> updateNotes(Notes notes);
}
