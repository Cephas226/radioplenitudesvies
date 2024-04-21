import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:radio_player/radio_player.dart';

import '../../consts/app_defaults.dart';
import '../../consts/app_images.dart';

class OldRadio extends StatefulWidget {
  const OldRadio({super.key});

  @override
  _OldRadioState createState() => _OldRadioState();
}

class _OldRadioState extends State<OldRadio> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: 'Radio Player',
      url: 'https://www.radioking.com/play/radioplenitudesvie',
      imagePath: AppImages.COVER,
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(title: const Center(child: Text("Ancienne version",style: TextStyle(fontWeight: FontWeight.bold),))),
          backgroundColor: Colors.black,
          body:SingleChildScrollView(
            child:
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: AppDefaults.defaultBoxShadow,
                        borderRadius: AppDefaults.defaulBorderRadius,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                              borderRadius: AppDefaults.defaulBorderRadius,
                              child: InkWell(
                                child: SizedBox(
                                  width: Get.width * 0.9,
                                  child: AspectRatio(
                                      aspectRatio: 13 / 15,
                                      child: Image.asset(
                                        AppImages.PLAYER,
                                        fit: BoxFit.cover,
                                      ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),

                Text(
                  metadata?[0] ?? 'Ecouter la radio...',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24,color: Colors.white),
                ),
                Text(
                  metadata?[1] ?? '',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                ),
              ],
            ),

          ),floatingActionButton: FloatingActionButton(
        onPressed: () {
          isPlaying ? _radioPlayer.stop() : _radioPlayer.play();
        },
        tooltip: 'Control button',
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
      ),);
  }
}