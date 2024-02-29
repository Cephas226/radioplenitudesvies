import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class TorrentScreenView extends StatefulWidget {
  DateTime selectedDate;
  DateTime lastDate;

  TorrentScreenView(
      {required this.selectedDate, required this.lastDate, super.key});

  @override
  _TorrentScreenViewState createState() => _TorrentScreenViewState();
}

class _TorrentScreenViewState extends State<TorrentScreenView> {
  //DateTime? selectedDate;
  Random random = new Random();

  @override
  void initState() {
    setState(() {
      //widget.selectedDate = DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
            body: Stack(
      children: [

      ],
    ));
  }

  _saveImage(url, name, context) async {
    if (await Permission.storage.request().isGranted) {
      ScaffoldMessenger.of(context as BuildContext)
          .showSnackBar(mysnackBar("Image sauvegardé"));
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {}
  }

  SnackBar mysnackBar(message) {
    return SnackBar(content: Text(message as String));
  }

  Future<void> shareNetworkImage(String imageUrl, String text) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final Directory directory = await getTemporaryDirectory();
    final File file = await File('${directory.path}/Image.png')
        .writeAsBytes(response.bodyBytes);
    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: text,
    );
  }
}
