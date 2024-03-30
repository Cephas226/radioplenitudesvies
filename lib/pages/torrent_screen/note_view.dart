import 'dart:io';
import 'dart:math';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radioplenitudesvie/pages/home/home_page.dart';
import 'package:radioplenitudesvie/pages/torrent_screen/torrent_view.dart';
import 'package:share_plus/share_plus.dart';
import '../../consts/app_defaults.dart';
import '../../consts/app_sizes.dart';
import '../../models/note.dart';
import '../../themes/text.dart';
import '../../widget/button.dart';
import '../../widget/text_field.dart';
import 'torrent_screen_controller.dart';
import 'package:http/http.dart' as http;

class NoteScreenView extends StatefulWidget {

  NoteScreenView(
      {super.key});

  @override
  _NoteScreenViewState createState() => _NoteScreenViewState();
}

class _NoteScreenViewState extends State<NoteScreenView> {

  final controller = Get.put(TorrentScreenController());

  void addNote() {
    if (controller.titleController.text.isEmpty ||
        controller.descriptionController.text.isEmpty) return;
    var note = Note(
      id: UniqueKey().toString(),
      title: controller.titleController.text,
      description: controller.descriptionController.text,
      cdt: DateTime.now(),
    );
    controller.titleController.text = '';
    controller.descriptionController.text = '';
    controller.addNote(note);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Ajouter vos notes",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  CustomTextFormField(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    borderRadius: BorderRadius.circular(5),
                    controller: controller.titleController,
                    height: 50.0,
                    hintText: "Titre",
                    nextFocus: controller.descriptioinFocus,
                  ),
                  CustomTextFormField(
                    padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                    focus: controller.descriptioinFocus,
                    borderRadius: BorderRadius.circular(5),
                    controller: controller.descriptionController,
                    hintText: "Entrer la description",
                    maxLines: 10,
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    title: "Valider",
                    icon: Icons.done,
                    onPressed: addNote,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
