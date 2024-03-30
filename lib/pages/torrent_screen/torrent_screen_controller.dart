import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:radioplenitudesvie/api/radio_web_service.dart';
import 'package:radioplenitudesvie/models/note.dart';
import 'package:radioplenitudesvie/models/torrent_model.dart';

class TorrentScreenController extends GetxController {
  var torrents = <Torrent>[].obs;
  var isLoading = false.obs;
  var isTorrent = true.obs;
  var notes = [].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  FocusNode descriptioinFocus = FocusNode();

  final TextEditingController textEditingController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    fetchTorrents(DateTime.now().toString().split(' ')[0]);
    try {
      Hive.registerAdapter(NoteAdapter());
    } catch (e) {
      print(e);
    }
    getNotes();
    super.onInit();
  }

  Future<void> fetchTorrents(selectedDate) async {
    try {
      isLoading(true);
      var articleTemp = await RadioWebService.fetchDataFromApI();
      if (articleTemp != null) {
        torrents(articleTemp
            .where((torrent) => torrent.date == selectedDate.toString())
            .toList());
      }
    } finally {
      isLoading(false);
    }
  }

  Future getNotes() async {
    Box box;
    try {
      box = Hive.box('db');
    } catch (error) {
      box = await Hive.openBox('db');
      print(error);
    }
    for (var n in notes) {
      notes.add(n);
    }
  }

  addNote(Note note) async {
    notes.add(note);
    var box = await Hive.openBox('db');
    box.put('notes', notes.toList());
    print("Note Object added $notes");
  }

  deleteNote(Note note) async {
    notes.remove(note);
    var box = await Hive.openBox('db');
    box.put('notes', notes.toList());
  }
}
