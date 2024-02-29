

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:radioplenitudesvie/pages/dashboard/dashboard_page.dart';
import 'package:radioplenitudesvie/pages/home/accueil_controller.dart';
import 'package:radioplenitudesvie/pages/play_list_screen/play_list_screen_controller.dart';

import '../../consts/app_defaults.dart';
import '../../consts/app_images.dart';
import '../../consts/app_sizes.dart';
import '../../models/author.dart';
import '../home/show_page_details.dart';

class PlayLlistScreenView extends StatefulWidget {
  const PlayLlistScreenView({super.key});

  @override
  _PlayLlistScreenViewState createState() => _PlayLlistScreenViewState();
}
final PlayLlistScreenController playLlistScreenController = Get.put(PlayLlistScreenController());
final AccueilController accueilController = Get.put(AccueilController());

class _PlayLlistScreenViewState extends State<PlayLlistScreenView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        extendBodyBehindAppBar: true,
        //bottomNavigationBar: const _BottomBar(),
        body:
        Obx(() =>
            Container(
            padding: const EdgeInsets.all(10.0),
            child:
            GridView.builder(
              itemCount: playLlistScreenController.authorList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0
              ),
              itemBuilder: (BuildContext context, int index){
                return
                  InkWell(
                    onTap: ()=>{
                      accueilController.resetPodcastList(),
                      playLlistScreenController.authorList[index].id,
                      accueilController.isPodCastPlaying.value = false,
                      accueilController.updateFilteredTargetedSongString(playLlistScreenController.authorList[index].id),
                Get.to(() => ShowDetails(playLlistScreenController.authorList[index].imagelink))
                  },
                      child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 9 / 9,
                        child: playLlistScreenController.authorList[index].imagelink.isNotEmpty
                            ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: playLlistScreenController.authorList[index].imagelink,
                          placeholder: (context, url) => const SpinKitThreeBounce(
                            color: Colors.redAccent,
                            size: 50.0,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                            : Image.asset(
                          AppImages.APPBAR1,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(left: 0, right: 0, bottom: 2, child:Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          boxShadow: AppDefaults.defaultBoxShadow,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:  Text(playLlistScreenController.authorList[index].name,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ))
                    ],
                  ));
              },
            )))
    );
  }
}
class GridOptions extends StatelessWidget {
  final Author author;
  const GridOptions({required this.author,super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child:
      CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: author.imagelink,
        placeholder: (context, url) => const SpinKitThreeBounce(
          color: Colors.redAccent,
          size: 50.0,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }}