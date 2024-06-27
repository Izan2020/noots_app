import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noots_app/constants/app_colors.dart';
import 'package:noots_app/constants/app_strings.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _addNotes() async {
    DateTime currentTime = DateTime.now();
    Notes newNotes = Notes(
        null,
        _titleController.text.toString(),
        currentTime.toString(),
        _contentController.text.toLowerCase(),
        '',
        null);
    _notesProvider.addNotes(newNotes);
    Navigator.pop(context);
  }

  @override
  void dispose() async {
    super.dispose();
    await _notesProvider.listOfNotes();
    await _notesProvider.clearStateOnChange();
  }

  @override
  Widget build(BuildContext context) {
    _notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: (value) {
              _notesProvider.onChangeValueTitle(value);
            },
            controller: _titleController,
            cursorColor: AppColors.black,
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: AppStrings.widgetTitleHint),
          ),
          iconTheme: const IconThemeData(color: AppColors.black),
          backgroundColor: AppColors.white,
          elevation: 0,
          actions: [
            Visibility(
              visible: _notesProvider.currentNotesTitle!.isEmpty ||
                      _notesProvider.currentNotesContent!.isEmpty
                  ? false
                  : true,
              child: GestureDetector(
                  onTap: () => {_addNotes()},
                  child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: const Icon(Icons.save,
                          color: AppColors.blue,
                          shadows: [
                            Shadow(
                              color: AppColors.blue,
                              offset: Offset(0.2, 0.2),
                              blurRadius: 29.0,
                            )
                          ]))),
            ),
          ],
        ),
        body: SizedBox(
          // <-- TextField width
          height: double.infinity, // <-- TextField height
          child: TextField(
            onChanged: (value) {
              _notesProvider.onChangeValueContent(value);
            },
            controller: _contentController,
            maxLines: null,
            cursorColor: AppColors.black,
            expands: true,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
                filled: true, hintText: AppStrings.widgetContentHint),
          ),
        ));
  }
}
