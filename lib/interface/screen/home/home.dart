import 'package:flutter/material.dart';
import 'package:noots_app/data/notes_database.dart';
import 'package:noots_app/interface/screen/add_note/add_note.dart';
import 'package:noots_app/interface/widget/home_widgets.dart';
import 'package:noots_app/provider/interface_provider.dart';
import 'package:noots_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import '../../../model/notes.dart';
import '../add_note/edit_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDeleteMode = false;
  late NotesProvider _notesProvider;
  late InterfaceProvider _interfaceProvider;

  Future<void> _deleteNote(Notes notes) async {
    final db =
        await $FloorAppDatabase.databaseBuilder("notes_database.db").build();
    final dao = await db.notesDao.deleteNotes(notes);
    return dao;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () async {
      return await _notesProvider.listOfNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    _notesProvider = Provider.of<NotesProvider>(context);
    _interfaceProvider = Provider.of<InterfaceProvider>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: HomeWidgets().homeAppBar(
              onTapAdd: () {
                _interfaceProvider.clearDeleteMode();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddNotesScreen();
                }));
              },
              onTapDeleteState: () {
                _interfaceProvider.setDeleteMode();
              },
              onTapDeleteAll: () {
                _notesProvider.deleteCheckedItems();
                return Future.delayed(const Duration(milliseconds: 300),
                    () async {
                  return await _notesProvider.listOfNotes();
                });
              },
              isDeleteStet: _interfaceProvider.isDeleteMode),
          body: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _notesProvider.notesList.length,
              itemBuilder: (context, index) {
                return ItemNotes(
                  notes: _notesProvider.notesList[index],
                  isDeleteState: _interfaceProvider.isDeleteMode,
                  onTapItem: () {
                    _interfaceProvider.clearDeleteMode();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditNoteScreen(
                          notesId: _notesProvider.notesList[index].id!);
                    }));
                  },
                );
              })),
    );
  }
}
