import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noots_app/constants/app_colors.dart';
import 'package:noots_app/constants/app_enum.dart';
import 'package:noots_app/constants/app_icons.dart';
import 'package:noots_app/constants/app_strings.dart';
import 'package:noots_app/util/strings.dart';

import '../../model/notes.dart';

class HomeWidgets {
  PreferredSizeWidget homeAppBar({
    required Function onTapAdd,
    required Function onTapDeleteState,
    required bool isDeleteStet,
    required Function onTapDeleteAll,
    required NoteState noteState,
  }) {
    return AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            ),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leadingWidth: isDeleteStet ? 70 : 50,
        leading: Visibility(
          visible: noteState == NoteState.empty ? false : true,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onTapDeleteState(),
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 900),
                    child: Icon(
                      !isDeleteStet ? AppIcons.delete : AppIcons.close,
                      color: !isDeleteStet ? AppColors.black : AppColors.gray,
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
                      child: const Icon(AppIcons.deleteRounded,
                          color: AppColors.red,
                          shadows: [
                            Shadow(
                              color: AppColors.red,
                              offset: Offset(0.2, 0.2),
                              blurRadius: 29.0,
                            )
                          ]),
                    ),
                  ))
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => noteState == NoteState.empty ? null : onTapAdd(),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Icon(Icons.add,
                  color: noteState == NoteState.empty
                      ? AppColors.transparent
                      : AppColors.blue,
                  shadows: const [
                    Shadow(
                      color: AppColors.blue,
                      offset: Offset(0.2, 0.2),
                      blurRadius: 18.0,
                    )
                  ]),
            ),
          )
        ],
        title: const Center(
          child: Text(
            AppStrings.widgetAppType,
            style: TextStyle(color: AppColors.black),
            textAlign: TextAlign.center,
          ),
        ));
  }
}

// ignore: must_be_immutable
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
                  activeColor: AppColors.blue,
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
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray,
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
                                  ? 'Updated ${timestampToHour(widget.notes.lastUpdate, AppStrings.timestampDayDateMonth)}'
                                  : timestampToHour(widget.notes.dateAdded,
                                      AppStrings.timestampDayDateMonth),
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
