import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
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

final AccueilController accueilController = Get.put(AccueilController());
final RxInt currentIndex = 0.obs;
final RxBool isPlaying = false.obs;
class ShowDetails extends StatelessWidget {
  String headerLink;
  ShowDetails(this.headerLink);

  @override
  Widget build(BuildContext context) {

    return
            Scaffold(
                backgroundColor: Colors.black,
                body:

                Obx(() =>(
                    SingleChildScrollView(
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
                                          aspectRatio: 18 / 15,
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
                          Positioned(
                              left: 0,
                              right: 0,
                              top: 100,
                              child: Column(
                                children: [
                                  Obx(() => Padding(
                                    padding: const EdgeInsets.only(right: 25, left: 25),
                                    child: Row(
                                      children: [
                                        Text(
                                          accueilController.formattedDuration(
                                              accueilController.position.value),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          child: Slider(
                                              activeColor: Colors.redAccent,
                                              inactiveColor: const Color(0xFFEFEFEF),
                                              value: accueilController
                                                  .position.value.inSeconds
                                                  .toDouble(),
                                              min: 0.0,
                                              max: accueilController.duration.value.inSeconds
                                                  .toDouble() +
                                                  1.0,
                                              onChanged: (double value) {
                                                accueilController.setPositionValue = value;
                                              },
                                              onChangeStart: (double value) {
                                                audioHandler.pause();
                                              },
                                              onChangeEnd: (double value) {
                                                audioHandler.play();
                                              }),
                                        ),
                                        Text(
                                          accueilController.formattedDuration(
                                              accueilController.duration.value),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon:
                                        const Icon(Icons.skip_previous, color: Colors.white),
                                        onPressed: accueilController
                                            .back, // Fonction pour aller à la piste précédente
                                      ),
                                      StreamBuilder<PlaybackState>(
                                        stream: audioHandler.playbackState,
                                        builder: (context, snapshot) {
                                          final playbackState = snapshot.data;
                                          final processingState = playbackState?.processingState;
                                          final playing = playbackState?.playing;
                                          if (processingState == AudioProcessingState.loading ||
                                              processingState == AudioProcessingState.buffering) {
                                            return const SpinKitThreeBounce(
                                              color: Colors.redAccent,
                                              size: 50.0,
                                            );
                                          } else if (playing != true) {
                                            return IconButton(
                                              icon: const Icon(Icons.play_arrow,
                                                  color: Colors.white),
                                              onPressed: audioHandler.play,
                                            );
                                          } else {
                                            print(isPlaying);
                                            return IconButton(
                                              icon: const Icon(Icons.pause, color: Colors.white),
                                              onPressed: audioHandler.pause,
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.skip_next, color: Colors.white),
                                        onPressed: accueilController
                                            .next, // Fonction pour passer à la piste suivante
                                      ),
                                    ],
                                  )
                                ],
                              )),
 Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: myWave(),
                          ),

                          Positioned(left: 250,
                              right: 0,
                              top: 50, child: IconButton(
                                icon: const Icon(Icons.expand_circle_down_outlined,
                                    color: Colors.white),
                                onPressed:()=>{
                                  Get.back()
                                },
                              )
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List<Widget>.generate(
                              accueilController.audioPodSourceList.length, (index) {
                            var podCast = accueilController.audioPodSourceList[index];
                            return Obx(() => InkWell(
                                onTap: () {
                                  accueilController.songPlayPodCast(
                                      '${accueilController.audioPodSourceList[index].uri}',
                                      index,
                                      '${accueilController.audioPodSourceList[index].tag.title}');
                                  accueilController.currentEmissionName.value =
                                      accueilController.audioPodSourceList[index].tag.title
                                          .toString();
                                },
                                child: PodcastListTile(
                                  podCast: podCast,
                                  textColor: (accueilController.currentEmissionName.value
                                      .contains(
                                      '${accueilController.audioPodSourceList[index].tag.title}'))
                                      ? Colors.white
                                      : Colors.white,
                                  styleContainer: BoxDecoration(
                                    color: (accueilController.currentEmissionName.value
                                        .contains(
                                        '${accueilController.audioPodSourceList[index].tag.title}'))
                                        ? const Color(0xFF2A2A2A)
                                        : Colors.transparent,
                                    boxShadow: AppDefaults.defaultBoxShadow,
                                    borderRadius: AppDefaults.defaulBorderRadius,
                                  ),
                                )));
                          }),
                        ),
                      ),
                    ],
                  ),
                ))));
            /*Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverAppBar(
                  stretch: true,
                  onStretchTrigger: () {
                    return Future<void>.value();
                  },
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    centerTitle: true,
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        headerLink.isNotEmpty?
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: headerLink,
                          placeholder: (context, url) => const SpinKitThreeBounce(
                            color: Colors.redAccent,
                            size: 50.0,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ):Image.asset(
                          AppImages.APPBAR1,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.DEFAULT_PADDING * 1.5),
                  sliver:
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        AppSizes.hGap20,
                        Obx(() => Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: accueilController.audioPodSourceList.isNotEmpty
                                ?
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              List<Widget>.generate(
                                  accueilController.audioPodSourceList.length,
                                      (index) {
                                    var audioPodSourceList =
                                        accueilController.audioPodSourceList;
                                    return Obx(() =>
                                        InkWell(
                                          child:
                                          AppUiHelper()
                                              .fileExention('${audioPodSourceList[index].tag.title}') == ".mp3"?
                                          PodcastListTile(
                                          textColor: (accueilController.currentEmissionName.value ==
                                              '${audioPodSourceList[index].tag.title}')
                                              ? Colors.white
                                              : Colors.black,
                                          podCast: audioPodSourceList[index], styleContainer: BoxDecoration(
                                          color: (accueilController.currentEmissionName.value ==
                                              '${audioPodSourceList[index].tag.title}')
                                              ? const Color(0xFF2A2A2A)
                                              : Colors.transparent,
                                          boxShadow: AppDefaults.defaultBoxShadow,
                                          borderRadius: AppDefaults.defaulBorderRadius,
                                        ),):Container(),onTap: () {
                                          accueilController.songPlayPodCast('${audioPodSourceList[index].uri}',index,'${audioPodSourceList[index].tag.title}');
                                          accueilController
                                              .currentEmissionName.value = audioPodSourceList[index].tag.title.toString();
                                          print('************');
                                          print('${audioPodSourceList[index].uri}');
                                        },));
                                  }),
                            )
                                : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Aucun podcast disponible ...',
                                  style: AppText.h6,
                             ))
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            accueilController.isPodCastPlaying.value?
            Positioned(left: 0, right: 0, bottom: 5, child: showBannerPodcast(
                const Utf8Decoder()
                    .convert(accueilController.currentEmissionName.toString().codeUnits),context)):Container()
          ],
        )*/
  }
}
