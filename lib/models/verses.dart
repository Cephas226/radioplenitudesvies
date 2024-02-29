import 'package:get/get.dart';

class Chapter {
  Chapter({
    this.bookNumber,
    this.verse,
    this.chapter,
    this.shortName,
    this.longName,
    this.text,
  });

  factory Chapter.fromMap(Map<String, dynamic> data) => Chapter(
        bookNumber: data["book_number"] as int,
        chapter: data["chapter"] as String,
        verse: data["verse"] as int,
        shortName: data["short_name"] as String,
        longName: data["long_name"] as String,
        text: data["text"] as String,
      );
  int? bookNumber;
  String? chapter;
  int? verse;
  String? shortName;
  String? longName;
  String? text;

  Map<String, dynamic> toMap() => {
        "book_number": bookNumber,
        "chapter": chapter,
        "verse": verse,
        "short_name": shortName,
        "long_name": longName,
        "text": text,
      };
}

class Verse {
  Verse({
    this.bookNumber,
    this.shortName,
    this.longName,
    this.verse,
    this.chapter,
    this.text,
  });

  factory Verse.fromMap(Map<String, dynamic> data) => Verse(
        bookNumber: data["book_number"] as int,
        shortName: data["short_name"] as String,
        longName: data["long_name"] as String,
        chapter: data["chapter"] as String,
        verse: data["verse"] as int,
        text: data["text"] as String,
      );

  int? bookNumber;
  String? shortName;
  String? longName;
  String? chapter;
  int? verse;
  String? text;

  Map<String, dynamic> toMap() => {
        "book_id": bookNumber,
        "short_name": shortName,
        "long_name": longName,
        "chapter": chapter,
        "verse": verse,
        "text": text,
      };
}

class Book {
  Book({
    this.bookNumber,
    this.shortName,
    this.longName,
    required this.isExpanded,
  });

  factory Book.fromMap(Map<String, dynamic> data) => Book(
        bookNumber: data["book_number"] as int,
        shortName: data["short_name"] as String,
        longName: data["long_name"] as String,
        isExpanded: false.obs,
      );

  int? bookNumber;
  String? shortName;
  String? longName;
  RxBool isExpanded = false.obs;

  Map<String, dynamic> toMap() => {
        "book_id": bookNumber,
        "short_name": shortName,
        "long_name": longName,
      };
}
