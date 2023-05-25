import 'package:floor/floor.dart';

@entity
class Notes {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;

  final String content;

  final String dateAdded;

  String? lastUpdate = "";
  String? category = "";
  bool is_checked = false;

  Notes(this.id, this.title, this.dateAdded, this.content, this.lastUpdate,
      this.category);
}
