import 'package:flutter/material.dart';
import 'package:noots_app/interface/screen/add_note/add_note.dart';
import 'package:noots_app/interface/widget/home_widgets.dart';
import 'package:noots_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import '../../../model/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NotesProvider _notesProvider;
  late List<Notes> _listOfNotes = [];

  Future<void> getAllNotes() async {
    await _notesProvider.listOfNotes();
    _listOfNotes = _notesProvider.notesList;
  }

  Future<void> deleteNote(Notes notes) async {
    await _notesProvider.deleteNote(notes);
    getAllNotes();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      return getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    _notesProvider = Provider.of<NotesProvider>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: HomeWidgets().homeAppBar(onTapAdd: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddNotesScreen();
            }));
          }),
          body: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _listOfNotes.length,
              itemBuilder: (context, index) {
                return ItemNotes(
                  notes: _listOfNotes[index],
                  onPressDelete: () {
                    deleteNote(_listOfNotes[index]);
                  },
                );
              })),
    );
  }
}
