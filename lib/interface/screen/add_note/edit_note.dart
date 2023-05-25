import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noots_app/model/notes.dart';
import 'package:noots_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';

class EditNoteScreen extends StatefulWidget {
  final int notesId;
  const EditNoteScreen({super.key, required this.notesId});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late NotesProvider _notesProvider;

  Future<void> getNotes() async {
    await _notesProvider.getNotes(widget.notesId);
    if (_notesProvider.currentNotes != null) {
      _titleController.text = _notesProvider.currentNotes!.title;
      _contentController.text = _notesProvider.currentNotes!.content;
    }
  }

  Future<void> updateNotes() async {
    DateTime currentTime = DateTime.now();
    String dateUpdated = currentTime.toString();
    String newTitle = _titleController.text.toString();
    String newContent = _contentController.text.toString();
    if (newTitle.isEmpty || newContent.isEmpty) {
      Fluttertoast.showToast(msg: "Fill the Blanks!");
      return;
    }
    Notes newNotes = Notes(
        widget.notesId,
        newTitle,
        _notesProvider.currentNotes!.dateAdded,
        newContent,
        dateUpdated.toString(),
        null);
    await _notesProvider.updateNotes(newNotes);
    _notesProvider.listOfNotes();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    Future.delayed(const Duration(milliseconds: 300), () {
      return _notesProvider.clearCurrentNotes();
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _notesProvider = Provider.of<NotesProvider>(context, listen: false);

    Future.delayed(const Duration(milliseconds: 300), () {
      return getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _titleController,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            GestureDetector(
                onTap: () => {updateNotes()},
                child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: const Icon(Icons.save))),
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
            decoration: const InputDecoration(filled: true),
          ),
        ));
  }
}
