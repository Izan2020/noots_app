import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noots_app/constants/app_colors.dart';
import 'package:noots_app/constants/app_strings.dart';
import 'package:noots_app/interface/screen/add_note/add_note.dart';
import 'package:noots_app/interface/widget/home_widgets.dart';
import 'package:noots_app/provider/interface_provider.dart';
import 'package:noots_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';
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

  Future<void> _clearDeleteState() async {
    return _interfaceProvider.clearDeleteMode();
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
          backgroundColor: AppColors.white,
          appBar: HomeWidgets().homeAppBar(
              checkedLists: _notesProvider.countOfCheckedItems(),
              noteState: _notesProvider.noteListState!,
              onTapAdd: () {
                _clearDeleteState();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddNotesScreen();
                }));
              },
              onTapDeleteState: () {
                _interfaceProvider.setDeleteMode();
              },
              onTapDeleteAll: () async {
                await _notesProvider.deleteCheckedItems();
                _clearDeleteState();
                await _notesProvider.listOfNotes();
              },
              isDeleteStet: _interfaceProvider.isDeleteMode),
          body: _notesProvider.notesList.isNotEmpty
              ? SizedBox(
                  height: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _notesProvider.notesList.length,
                      itemBuilder: (context, index) {
                        return ItemNotes(
                          onSlidableItem: () {
                            _notesProvider.deleteNotesById(
                                _notesProvider.notesList[index].id!);
                            _notesProvider.listOfNotes();
                          },
                          notes: _notesProvider.notesList[index],
                          isDeleteState: _interfaceProvider.isDeleteMode,
                          onTapItem: () {
                            _clearDeleteState();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EditNoteScreen(
                                  notesId: _notesProvider.notesList[index].id!);
                            }));
                          },
                        );
                      }),
                )
              : Center(
                  child: Container(
                  margin: const EdgeInsets.only(bottom: 52),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.air_outlined,
                        size: 72,
                        color: AppColors.black,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                AppStrings.widgetNotesEmpty,
                                style: TextStyle(
                                    color: AppColors.gray, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    _clearDeleteState();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const AddNotesScreen();
                                    }));
                                  },
                                  child: const Text(
                                    AppStrings.widgetClickToAdd,
                                    style: TextStyle(
                                        color: AppColors.blue,
                                        fontSize: 12,
                                        shadows: [
                                          Shadow(
                                            color: AppColors.blue,
                                            offset: Offset(0.2, 0.2),
                                            blurRadius: 29.0,
                                          )
                                        ]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ))),
    );
  }
}
