import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noots_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import '../../../model/notes.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  late NotesProvider _notesProvider;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  Future<void> addNotes() async {
    DateTime now = DateTime.now();
    Notes notes = Notes(null, _titleController.text.toString(), now.toString(),
        _contentController.text.toString(), '', '');
    await _notesProvider.addNotes(notes);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    Future.delayed(const Duration(milliseconds: 300), () {
      return _notesProvider.listOfNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    _notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _titleController,
            cursorColor: Colors.black,
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: 'Title...'),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            GestureDetector(
                onTap: () => {addNotes()},
                child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: const Icon(
                      Icons.save,
                      color: Colors.blueAccent,
                    ))),
          ],
        ),
        body: SizedBox(
          // <-- TextField width
          height: double.infinity, // <-- TextField height
          child: TextField(
            controller: _contentController,
            maxLines: null,
            cursorColor: Colors.black,
            expands: true,
            keyboardType: TextInputType.multiline,
            decoration:
                const InputDecoration(filled: true, hintText: 'Notes...'),
          ),
        ));
  }
}
