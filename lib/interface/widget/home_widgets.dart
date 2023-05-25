// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:noots_app/interface/screen/add_note/edit_note.dart';
import 'package:noots_app/util/strings.dart';

import '../../model/notes.dart';

class HomeWidgets {
  PreferredSizeWidget homeAppBar({
    required Function onTapAdd,
    required Function onTapDeleteState,
    required bool isDeleteStet,
    required Function onTapDeleteAll,
  }) {
    return AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: isDeleteStet ? 70 : 50,
        leading: Row(
          children: [
            GestureDetector(
              onTap: () => onTapDeleteState(),
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 900),
                  child: Icon(
                    !isDeleteStet ? Icons.delete_rounded : Icons.close,
                    color: !isDeleteStet ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            Visibility(
                visible: isDeleteStet,
                child: GestureDetector(
                  onTap: () => onTapDeleteAll(),
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                ))
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => onTapAdd(),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: const Icon(
                Icons.add,
                color: Colors.blue,
              ),
            ),
          )
        ],
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Center(
            child: Text(
              'Notes',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ));
  }
}

class ItemNotes extends StatefulWidget {
  final Notes notes;
  bool isDeleteState;
  Function onTapItem;
  ItemNotes({
    Key? key,
    required this.notes,
    required this.isDeleteState,
    required this.onTapItem,
  }) : super(key: key);

  @override
  State<ItemNotes> createState() => _ItemNotesState();
}

class _ItemNotesState extends State<ItemNotes> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: widget.isDeleteState ? 70 : 0,
          child: Visibility(
              visible: widget.isDeleteState,
              child: Checkbox(
                  value: widget.notes.is_checked,
                  onChanged: (value) {
                    setState(() {
                      widget.notes.is_checked = value!;
                    });
                  })),
        ),

        Expanded(
          child: GestureDetector(
            onTap: () => widget.onTapItem(),
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
                        widget.notes.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        constraints:
                            const BoxConstraints(maxWidth: 400, minWidth: 100),
                        child: Text(
                            truncateWithEllipsis(120, widget.notes.content)),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(right: 14, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.notes.lastUpdate!.isNotEmpty
                                  ? 'Updated ${timestampToHour(widget.notes.lastUpdate, 'EEEE, dd MMMM ')}'
                                  : timestampToHour(
                                      widget.notes.dateAdded, 'EEEE, dd MMMM '),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
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
        ),
        // Other widgets in the Row...
      ],
    );
  }
}
