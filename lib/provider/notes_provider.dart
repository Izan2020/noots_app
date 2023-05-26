import 'package:flutter/foundation.dart';
import 'package:noots_app/constants/app_enum.dart';
import 'package:noots_app/constants/app_strings.dart';
import 'package:noots_app/data/notes_database.dart';

import '../model/notes.dart';

class NotesProvider extends ChangeNotifier {
  List<Notes> _notesList = [];
  List<Notes> get notesList => _notesList;

  Notes? _currentNotes;
  Notes? get currentNotes => _currentNotes;

  String? _currentNotesTitle = '';
  String? get currentNotesTitle => _currentNotesTitle;

  String? _currentNotesContent = '';
  String? get currentNotesContent => _currentNotesContent;

  Future<void> onChangeValueTitle(String title) async {
    _currentNotesTitle = title;
    notifyListeners();
  }

  Future<void> onChangeValueContent(String content) async {
    _currentNotesContent = content;
    notifyListeners();
  }

  Future<void> clearStateOnChange() async {
    _currentNotesContent = '';
    _currentNotesTitle = '';
    notifyListeners();
  }

  NoteState? _noteListState = NoteState.init;
  NoteState? get noteListState => _noteListState;

  _setNoteState(NoteState state) {
    _noteListState = state;
    notifyListeners();
  }

  Future<AppDatabase> _createDatabase() async {
    return await $FloorAppDatabase
        .databaseBuilder(AppStrings.appDatabase)
        .build();
  }

  Future<void> listOfNotes() async {
    final database = await _createDatabase();
    final dao = await database.notesDao.getAllNotes();
    if (dao.isNotEmpty) {
      _setNoteState(NoteState.none);
      _notesList = dao;
    } else {
      _setNoteState(NoteState.empty);
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
    listOfNotes();
    notifyListeners();
  }

  int countOfCheckedItems() {
    final listOfChecked = _notesList.map((e) => e.is_checked);
    int totalChecked = listOfChecked.length;
    return totalChecked;
  }

  Future<void> deleteNotesById(int id) async {
    final database = await _createDatabase();
    final dao = await database.notesDao.deleteById(id);
    return dao;
  }

  void clearCurrentNotes() {
    _currentNotes = null;
    notifyListeners();
  }
}
