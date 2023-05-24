import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:noots_app/interface/screen/add_note/edit_note.dart';
import 'package:noots_app/util/strings.dart';

import '../../model/notes.dart';

class HomeWidgets {
  PreferredSizeWidget homeAppBar({required Function onTapAdd}) {
    return AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color

            ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () => onTapAdd(),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          )
        ],
        title: const Center(
          child: Text(
            'Notes',
            style: TextStyle(color: Colors.black),
          ),
        ));
  }
}

class ItemNotes extends StatelessWidget {
  final Notes notes;
  final Function onPressDelete;
  const ItemNotes(
      {required this.notes, super.key, required this.onPressDelete});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: onPressDelete(),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EditNoteScreen(notesId: notes.id!);
        })),
        child: Container(
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notes.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    constraints:
                        const BoxConstraints(maxWidth: 400, minWidth: 100),
                    child: Text(truncateWithEllipsis(120, notes.content)),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(right: 14, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          notes.lastUpdate!.isNotEmpty
                              ? 'Updated ${timestampToHour(notes.lastUpdate, 'EEEE, dd MMMM ')}'
                              : timestampToHour(
                                  notes.dateAdded, 'EEEE, dd MMMM '),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.end,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
