import 'dart:convert';
import'dart:io' show Platform;
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:radioplenitudesvie/pages/dashboard/dashboard_controller.dart';
import 'package:radioplenitudesvie/pages/home/thought_title.dart';
import 'package:radioplenitudesvie/pages/planning_screen/planning_screen_controller.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../consts/app_defaults.dart';
import '../../main.dart';
import 'accueil_controller.dart';
import 'podcast_tile.dart';
import '../../../consts/app_images.dart';
import '../../../consts/app_sizes.dart';
import '../../themes/text.dart';

import 'show_page_details.dart';
import 'show_title.dart';

final AccueilController accueilController = Get.put(AccueilController());
final DashboardController dashboardController = Get.put(DashboardController());
final PlanningScreenController planningScreenController =
    Get.put(PlanningScreenController());
Color getRandomColor() {
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  ) ?? Colors.transparent;
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        body:
        CustomScrollView(
              physics:  const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  floating: true,
                  actions: [
                    Platform.isIOS ?
                    planningAndNotifications(context):Container(),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.DEFAULT_PADDING * 1),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        AppSizes.hGap5,
                        !Platform.isIOS ?
                        planningAndNotifications(context):Container(),
                        const _CarrousselBar(),
                        AppSizes.hGap5,
                        myPlayerRadio(),
                        AppSizes.hGap5,
                        const _ShowsPocketsList(),
                        AppSizes.hGap5,
                        const _RecentShowsList(),
                        AppSizes.hGap5,
                        const _WordBreadStories(),
                        AppSizes.hGap30 ,
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }
}

class _CarrousselBar extends StatelessWidget {
  const _CarrousselBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
       !accueilController.isAnnounceLoading.value?
       CarouselSlider.builder(
          itemCount: accueilController.announceList.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: accueilController.announceList[index]
                              ['imagelink']
                          .toString(),
                      placeholder: (context, url) => const SpinKitThreeBounce(
                        color: Colors.redAccent,
                        size: 50.0,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 10,
            enableInfiniteScroll: false,
            height: MediaQuery.of(context).size.height / 5.5,
          ),
        ):
       const SpinKitThreeBounce(
         color: Colors.redAccent,
         size: 50.0,
       ),
    );
  }
}

class _ShowsPocketsList extends StatelessWidget {
  const _ShowsPocketsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    !accueilController.isPocketLoading.value?
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          accueilController.showList.isNotEmpty?
          Text(
            'Nos émissions',
            style: AppText.h6,
          ):Container(),
          AppSizes.hGap5,
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() =>
              accueilController.showList.isNotEmpty ?
              Row(
                children: List<Widget>.generate(
                    accueilController.showList.length,
                        (index) {
                      return ShowTile(
                        show: accueilController
                            .showList[index],
                        onTap: () {
                          accueilController
                              .resetPodcastList();
                          accueilController.isPodCastPlaying
                              .value = false;
                          accueilController
                              .updateFilteredShows(
                              accueilController
                                  .showList[index].key);
                          Get.to(() => ShowDetails(
                              accueilController
                                  .showList[index]
                                  .imagelink));
                        },
                      );
                    }),
              )
                  :const SpinKitThreeBounce(
                color: Colors.redAccent,
                size: 50.0,
              ))),
        ],
      ),
    ):
    Container()
    );
  }
}

class _RecentShowsList extends StatelessWidget {
  const _RecentShowsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    !accueilController.isShowLoading.value?
    Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          accueilController.showList.isNotEmpty?
          Text(
            'Nos émissions récentes',
            style: AppText.h6,
          ):Container(),
          AppSizes.hGap5,
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(
                  accueilController.audioSourceList
                      .take(6)
                      .length, (index) {
                var podCast =
                accueilController.audioSourceList[index];
                return Obx(() => InkWell(
                    onTap: () {
                      accueilController.songPlayPodCast(
                          '${accueilController.audioSourceList[index].uri}',
                          index,
                          '${accueilController.audioSourceList[index].tag.title}');
                      accueilController
                          .currentEmissionName.value =
                          accueilController
                              .audioSourceList[index].tag.title
                              .toString();
                    },
                    child:
                    !accueilController.isShowLoading.value?
                    PodcastListTile(
                      podCast: podCast,
                      textColor: (accueilController
                          .currentEmissionName.value
                          .contains(
                          '${accueilController.audioSourceList[index].tag.title}'))
                          ? Colors.white
                          : Colors.black,
                      styleContainer: BoxDecoration(
                        color: (accueilController
                            .currentEmissionName.value
                            .contains(
                            '${accueilController.audioSourceList[index].tag.title}'))
                            ? const Color(0xFF2A2A2A)
                            : Colors.transparent,
                        boxShadow: AppDefaults.defaultBoxShadow,
                        borderRadius:
                        AppDefaults.defaulBorderRadius,
                      ),
                    ):const SpinKitThreeBounce(
                      color: Colors.redAccent,
                      size: 50.0,
                    )
                )
                );
              }),
            ),
          ),
        ],
      ),
    ):
    const SpinKitThreeBounce(
      color: Colors.redAccent,
      size: 50.0,
    ),
    );
  }
}

class _WordBreadStories extends StatelessWidget {
  const _WordBreadStories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    accueilController.wordTextCoverLink.isNotEmpty ?
    SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✝️ Parole de Vie',
              style: AppText.h6,
            ),
            AppSizes.hGap10,
            ThoughtCoover(
                cover: accueilController
                    .wordTextCoverLink
                    .toString(),
                contentList:
                accueilController.wordTextList),

          ],
        )):
     Container(),
    );
  }
}

Container switcher(){
   return Container(
           decoration: BoxDecoration(
             color: const Color.fromARGB(255, 27, 6, 6),
             boxShadow: AppDefaults.defaultBoxShadow,
             borderRadius: AppDefaults.defaulBorderRadius,
           ),
           padding: const EdgeInsets.all(5.0),
      child: Center(
          child: Text(
              "Ancienne Version",
              style: AppText.b1.copyWith(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ))));
}

Row planningAndNotifications (BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    IconButton(
      icon:
      const Icon(Icons.notifications, color: Colors.black),
      onPressed: () {},
    ),
    IconButton(
      icon:
      const Icon(Icons.calendar_month, color: Colors.black),
      onPressed: () {
        accueilController.fetchPlanning(accueilController.currentDayIndex);
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            accueilController.getSelectedDay(accueilController.currentDayIndex).toString(),
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: accueilController.planningItems.length,
                      itemBuilder: (context, index) {
                        Color cardColor = getRandomColor();
                        return
                          Card(
                            margin: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration:  BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color:cardColor,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      const Utf8Decoder().convert('${accueilController.planningItems[index]['emission']}'.codeUnits),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                      style: AppText.b1.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AppSizes.hGap10,

                                    Text(
                                      accueilController.planningItems[index]['hour'].toString(),
                                      style: const TextStyle(fontSize: 12.0),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  ],);
}

Container ShowBannerPodcast(String textEmission) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 27, 6, 6),
      boxShadow: AppDefaults.defaultBoxShadow,
      borderRadius: AppDefaults.defaulBorderRadius,
    ),
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: AppDefaults.defaulBorderRadius,
          child: SizedBox(
            width: Get.width * 0.1,
            child: AspectRatio(
              aspectRatio: 8 / 8,
              child: Image.asset(
                AppImages.COVER,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextScroll(
                            textEmission,
                            style: AppText.b1.copyWith(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(25, 0)),
                          ))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<PlaybackState>(
                        stream: audioHandler.playbackState,
                        builder: (context, snapshot) {
                          final playbackState = snapshot.data;
                          final processingState =
                              playbackState?.processingState;
                          final playing = playbackState?.playing;
                          if (processingState == AudioProcessingState.loading ||
                              processingState ==
                                  AudioProcessingState.buffering) {
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
                            return IconButton(
                              icon:
                                  const Icon(Icons.pause, color: Colors.white),
                              onPressed: audioHandler.pause,
                            );
                          }
                        },
                      ),
                      /*StreamBuilder<bool>(
                            stream: audioHandler.playbackState
                                .map((state) => state.playing)
                                .distinct(),
                            builder: (context, snapshot) {
                              final playing = snapshot.data ?? false;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (playing)
                                    _button(Icons.pause, audioHandler.stop)
                                  else
                                    _button(Icons.play_arrow, audioHandler.play),
                                ],
                              );
                            },
                          ),*/
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}

IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
      icon: Icon(iconData, color: Colors.white),
      onPressed: onPressed,
    );

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

Container myPlayerRadio() {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 27, 6, 6),
      boxShadow: AppDefaults.defaultBoxShadow,
      borderRadius: AppDefaults.defaulBorderRadius,
    ),
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: AppDefaults.defaulBorderRadius,
          child: SizedBox(
            width: Get.width * 0.1,
            child: AspectRatio(
              aspectRatio: 8 / 8,
              child: Image.asset(
                AppImages.COVER,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: InkWell(
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: Text(
                                      "Cliquez ici pour écouter la radio 📻",
                                      style: AppText.b1.copyWith(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )))),
                          onTap: () => {accueilController.songPlayRadio()})),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
