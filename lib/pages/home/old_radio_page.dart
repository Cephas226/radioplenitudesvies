import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:radio_player/radio_player.dart';
import '../../consts/app_defaults.dart';
import '../../main.dart';
import '../../utils/ui_helper.dart';
import 'accueil_controller.dart';
import 'home_page.dart';
import '../../widget/podcast_tile.dart';

import '../../../consts/app_images.dart';
import '../../../consts/app_sizes.dart';
import '../../themes/text.dart';
import 'package:get/get.dart';

class OldRadio extends StatefulWidget {
  const OldRadio({super.key});

  @override
  _OldRadioState createState() => _OldRadioState();
}

class _OldRadioState extends State<OldRadio> {


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 25,
              color: Colors.white),
          onPressed: () => {Get.back()},
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: 
          Obx(() => Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 50, horizontal: 20),
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
              IconButton(
                icon: Icon(
                  color: Colors.white,
                  size: 50,
                  accueilController.isPlaying.value
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
                onPressed: () {
                  accueilController.isPodCastPlaying.value =false;
                  accueilController.pause();
                  accueilController.isPlaying.value
                      ? accueilController.radioPlayer.stop()
                      : accueilController.radioPlayer.play();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  accueilController.metadataverse.isNotEmpty?  Text(
                    accueilController.metadataverse[0] ?? 'Cliquer pour jouer',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white),
                  ):Container(),
                  const Text(' | ',style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white),
                  ),
                  accueilController.metadataverse.isNotEmpty?
                  Text(
                    accueilController.metadataverse[1] ?? '',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white),
                  ):Container(),
                ],
              ),
            ],
          ))
        ));
  }
}
