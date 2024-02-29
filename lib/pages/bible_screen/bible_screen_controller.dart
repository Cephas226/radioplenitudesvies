import 'package:get/get.dart';
import 'package:radioplenitudesvie/dbHelper/bible_db_helper.dart';
import 'package:radioplenitudesvie/models/verses.dart';
import 'package:radioplenitudesvie/widget/fr-fr_aelf.json.dart';

class BibleScreenController extends GetxController {
  var chapterVerses = <Verse>[].obs;
  var bookListChapters= <dynamic>[].obs;
  Map<String, dynamic> bibleIndex = bibleIndexMap;
  var booksList = <Book>[].obs;
  var currentBook = "".obs;
  var currentChapter = "".obs;
  var currentshortName = "".obs;
  var chNbr = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadInfo('Génèse','Gn', '1');
    loadAllBooks();
  }

  Future<void> loadInfo(String bookName,String book, String chapter) async {
    currentBook.value = book;
    currentChapter.value = chapter;
    currentshortName.value = bookName;
    var list = await BibleDatabaseHelper.db.getVerses(book, chapter);
    chapterVerses.value = list;
  }
  Future<void> loadChapters(String bookNameShort) async {
    var blChp = bibleIndex[bookNameShort]['chapters'];
    bookListChapters.value = blChp as List;
  }
  Future<void> loadAllBooks() async {
    var list = await BibleDatabaseHelper.db.getBooksAll();
    booksList.value = list;
  }
  loadChNbr (String? string) {
    BibleDatabaseHelper.db
        .getChapterNumber(string)
        .then((value) {
      chNbr.value = value;
      print(chNbr);
    });
  }
  Future<void> loadNextChapter(String book, String chapter) async {
    currentBook.value = book;
    currentChapter.value = chapter;
    int nextChapter = int.parse(currentChapter.value) + 1;

    await loadInfo(currentshortName.value,currentBook.value, nextChapter.toString());
    update();
  }

  Future<void> loadPreviousChapter(String book, String chapter) async {
    currentBook.value = book;
    currentChapter.value = chapter;
    int previousChapter = int.parse(currentChapter.value) - 1;

    if (previousChapter >= 1) {
      await loadInfo(currentshortName.value,currentBook.value, previousChapter.toString());
    } else {}
    update();
  }
}
