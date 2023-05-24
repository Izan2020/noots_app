import 'package:flutter/foundation.dart';
import 'package:noots_app/data/notes_database.dart';

import '../model/notes.dart';

class NotesProvider extends ChangeNotifier {
  List<Notes> _notesList = [];
  List<Notes> get notesList => _notesList;

  Notes? _currentNotes;
  Notes? get currentNotes => _currentNotes;

  Future<void> listOfNotes() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('notes_database.db').build();
    final dao = await database.notesDao.getAllNotes();
    debugPrint("Length ${dao.length}");
    if (dao.isNotEmpty) {
      _notesList = dao;
      notifyListeners();
    }
  }

  Future<void> addNotes(Notes notes) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('notes_database.db').build();
    final dao = await database.notesDao.insertNotes(notes);
    notifyListeners();
    return dao;
  }

  Future<void> deleteNote(Notes notes) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('notes_database.db').build();
    final dao = await database.notesDao.deleteNotes(notes);
    notifyListeners();
    return dao;
  }

  Future<void> updateNotes(Notes notes) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('notes_database.db').build();
    final dao = await database.notesDao.updateNotes(notes);
    notifyListeners();
    return dao;
  }

  Future<void> getNotes(int id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('notes_database.db').build();
    final dao = await database.notesDao.selectNote(id);
    debugPrint("$dao");
    _currentNotes = dao;
    notifyListeners();
  }

  Future<void> clearCurrentNotes() async {
    _currentNotes = null;
    notifyListeners();
  }
}
