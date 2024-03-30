import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(2)
  String title;
  @HiveField(3)
  DateTime cdt;
  @HiveField(4)
  String description;
  @HiveField(1)
  String id;

  Note({
    required this.title,
    required this.description,
    required this.cdt,
    required this.id,
  });
  Note.fromJson(Map json)
      : title = json['title'].toString(),
        cdt = json['cdt'] as DateTime,
        description = json['description'].toString(),
        id = json['id'].toString();
  toJson() {
    return {
      'id': id,
      'title': title,
      'cdt': cdt,
      'description': description,
    };
  }
}
