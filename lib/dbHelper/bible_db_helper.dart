import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radioplenitudesvie/models/verses.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BibleDatabaseHelper {
  static Database? _bibleDb;
  static BibleDatabaseHelper? _bibleDatabaseHelper;

  String table = 'verses';
  BibleDatabaseHelper._createInstance();

  static final BibleDatabaseHelper db = BibleDatabaseHelper._createInstance();

  factory BibleDatabaseHelper() {
    _bibleDatabaseHelper ??= BibleDatabaseHelper._createInstance();
    return _bibleDatabaseHelper!;
  }

  Future<Database> get database async {
    _bibleDb ??= await initializeDatabase();
    return _bibleDb!;
  }

  Future<Database> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'LSG.db');
    bool databaseExists = await File(path).exists();
    if (!databaseExists) {
      ByteData data = await rootBundle.load('assets/LSG.db');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }
    var myDatabase = await openDatabase(path, version: 1);
    return myDatabase;
  }

  Future<int> getCount(tableName) async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }

  Future<int> getCountBible(tableName) async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }
  // get number of chapter in a book
  Future<int> getChapterNumber(String? book) async {
    Database db = await database;
    final List<Map> result =
    await db.rawQuery(
        'SELECT COUNT (*) FROM chapters WHERE book=?;',
        [book]);
    int count = int.parse(result[0]["COUNT (*)"].toString());
    return count;
  }
  Future<List<Map<String, dynamic>>> getVerseMapList() async {
    Database db = await database;
    var result = await db.query(table, orderBy: "id ASC");
    return result;
  }

  Future<List<Verse>> getVerses(String book, String chapter) async {
    Database database = await initializeDatabase();

    List<Map<String, dynamic>> result = await database.rawQuery(
        'SELECT verses.book_number, verses.chapter, books_all.short_name, books_all.long_name, verses.verse,verses.text FROM verses LEFT JOIN books_all ON verses.book_number = books_all.book_number where books_all.short_name like ? and verses.chapter = ?',
        [book, chapter]);

    List<Verse> output = [];
    for (var element in result) {
      output.add(Verse(
          bookNumber: element["book_number"] as int,
          shortName: element["short_name"] as String,
          chapter: element["short_name"] as String,
          longName: element["long_name"] as String,
          verse: element["verse"] as int,
          text: element["text"] as String));
    }

    return output;
  }

  Future<List<Book>> getBooksAll() async {
    Database database = await initializeDatabase();

    List<Map<String, dynamic>> result =
        await database.rawQuery('SELECT * FROM books_all');

    List<Book> output = [];
    for (var element in result) {
      output.add(Book(
          bookNumber: element["book_number"] as int,
          shortName: element["short_name"] as String,
          longName: element["long_name"] as String,
          isExpanded: false.obs));
    }

    return output;
  }

  Future<List<Verse>> getVerseList() async {
    var verseMapList = await getVerseMapList();
    int count = await getCount(table);

    List<Verse> versesList = <Verse>[];
    for (int i = 0; i < count; i++) {
      versesList.add(Verse.fromMap(verseMapList[i]));
    }
    return versesList;
  }

  close() async {
    var db = await database;
    var result = db.close();
    return result;
  }
}
