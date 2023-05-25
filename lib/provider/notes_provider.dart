import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noots_app/data/notes_database.dart';

import '../model/notes.dart';

class NotesProvider extends ChangeNotifier {
  List<Notes> _notesList = [];
  List<Notes> get notesList => _notesList;

  Notes? _currentNotes;
  Notes? get currentNotes => _currentNotes;

  Future<AppDatabase> _createDatabase() async {
    return await $FloorAppDatabase.databaseBuilder('notes_database.db').build();
  }

  Future<void> listOfNotes() async {
    final database = await _createDatabase();
    final dao = await database.notesDao.getAllNotes();
    debugPrint(dao.length.toString());
    if (dao.isNotEmpty) {
      _notesList = dao;
    }
    notifyListeners();
  }

  Future<void> addNotes(Notes notes) async {
    final database = await _createDatabase();
    final dao = await database.notesDao.insertNotes(notes);
    notifyListeners();
    return dao;
  }

  Future<void> updateNotes(Notes notes) async {
    final database = await _createDatabase();
    final dao = await database.notesDao.updateNotes(notes);
    notifyListeners();
    return dao;
  }

  Future<void> getNotes(int id) async {
    final database = await _createDatabase();
    final dao = await database.notesDao.selectNote(id);
    debugPrint("$dao");
    _currentNotes = dao;
    notifyListeners();
  }

  Future<void> deleteCheckedItems() async {
    final database = await _createDatabase();
    for (var note in _notesList) {
      if (note.is_checked) {
        await database.notesDao.deleteById(note.id!);
      }
    }

    notifyListeners();
  }

  void clearCurrentNotes() {
    _currentNotes = null;
    notifyListeners();
  }
}
