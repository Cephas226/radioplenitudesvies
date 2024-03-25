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
import 'package:lottie/lottie.dart';
import 'package:radioplenitudesvie/pages/dashboard/dashboard_controller.dart';
import 'package:radioplenitudesvie/widget/show_special_title.dart';
import 'package:radioplenitudesvie/widget/thought_title.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../consts/app_defaults.dart';
import '../../main.dart';
import '../../widget/hero_page_route.dart';
import 'accueil_controller.dart';
import '../../widget/podcast_tile.dart';
import '../../../consts/app_images.dart';
import '../../../consts/app_sizes.dart';
import '../../themes/text.dart';

import 'show_page_details.dart';
import '../../widget/show_title.dart';
import '../../widget/torrent_title.dart';

final AccueilController accueilController = Get.put(AccueilController());
final DashboardController dashboardController = Get.put(DashboardController());

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: accueilController.refreshList,
        child: Obx(() => Scaffold(
            backgroundColor: accueilController.buttonColor.value == Colors.white
                ? Colors.black
                : Colors.white,
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.DEFAULT_PADDING * 1.5),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        AppSizes.hGap30,
                        pageTitle("Home", Colors.black, 20),
                        const _CarrousselBar(),
                        AppSizes.hGap30,
                        myPlayerRadio(),
                        emissionBar(),
                        recentPodCast(context),
                        lifeWord(),
                        ourReplay(),
                        AppSizes.hGap50,
                      ],
                    ),
                  ),
                ),
              ],
            ))));
  }
}

class _CarrousselBar extends StatelessWidget {
  const _CarrousselBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => CarouselSlider.builder(
          itemCount: accueilController.announceList.length > 5
              ? 5
              : accueilController.announceList.length,
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
        ));
  }
}

Widget showBannerPodcast(String textEmission, BuildContext context) {
  return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 27, 6, 6),
        boxShadow: AppDefaults.defaultBoxShadow,
        borderRadius: AppDefaults.defaulBorderRadius,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: AppDefaults.defaulBorderRadius,
                child: SizedBox(
                  width: Get.width * 0.1,
                  child: AspectRatio(
                    aspectRatio: 4 / 4,
                    child: Image.asset(
                      AppImages.COVER,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
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
               Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<PlaybackState>(
                          stream: audioHandler.playbackState,
                          builder: (context, snapshot) {
                            final playbackState = snapshot.data;
                            final processingState =
                                playbackState?.processingState;
                            final playing = playbackState?.playing;
                            if (processingState ==
                                    AudioProcessingState.loading ||
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
                                icon: const Icon(Icons.pause,
                                    color: Colors.white),
                                onPressed: audioHandler.pause,
                              );
                            }
                          },
                        )
                      ],
                    )
            ],
          ),
          // accueilController.isPodCastPlaying.value?
        ],
      ));
}

Widget myPlayerRadio() {
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

Widget emissionBar() {
  return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎙️ Nos émissions',
              style: AppText.h6.copyWith(fontWeight: FontWeight.bold)),
          AppSizes.hGap15,
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: List<Widget>.generate(
                        accueilController.showList.length, (index) {
                      return ShowTile(
                        show: accueilController.showList[index],
                        onTap: () {
                          accueilController.resetPodcastList();
                          accueilController.isPodCastPlaying.value = false;
                          accueilController.updateFilteredShows(
                              accueilController.showList[index].key);
                          Get.to(() => ShowDetails(
                              accueilController.showList[index].imagelink));
                        },
                      );
                    }),
                  ))),
        ],
      ));
}

Widget recentPodCast(BuildContext context) {
  return Hero(
      tag: "HeroOne",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📻 Emission récentes',
            style: AppText.h6.copyWith(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(
                  accueilController.audioSourceList.take(6).length, (index) {
                var podCast = accueilController.audioSourceList[index];
                return Obx(() => InkWell(
                    onTap: () {
                      accueilController.songPlayPodCast(
                          '${accueilController.audioSourceList[index].uri}',
                          index,
                          '${accueilController.audioSourceList[index].tag.title}');
                      accueilController.currentEmissionName.value =
                          accueilController.audioSourceList[index].tag.title
                              .toString();
                      Navigator.of(context).push(
                        HeroPageRoute(
                          tag: 'hero',
                          child: const SecondScreen(),
                          initElevation: 6.0,
                          initShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          initBackgroundColor:Colors.white
                        ),
                      );
                    },
                    child: PodcastListTile(
                      podCast: podCast,
                      textColor: (accueilController.currentEmissionName.value
                              .contains(
                                  '${accueilController.audioSourceList[index].tag.title}'))
                          ? Colors.white
                          : Colors.black,
                      styleContainer: BoxDecoration(
                        color: (accueilController.currentEmissionName.value
                                .contains(
                                    '${accueilController.audioSourceList[index].tag.title}'))
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
      ));
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}
class _SecondScreenState extends State<SecondScreen> {

  bool showMyWave = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showMyWave = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
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

                  showMyWave
                      ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: myWave(),
                  )
                      : Container(),

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
                      accueilController.audioSourceList.take(6).length, (index) {
                    var podCast = accueilController.audioSourceList[index];
                    return Obx(() => InkWell(
                        onTap: () {
                          accueilController.songPlayPodCast(
                              '${accueilController.audioSourceList[index].uri}',
                              index,
                              '${accueilController.audioSourceList[index].tag.title}');
                          accueilController.currentEmissionName.value =
                              accueilController.audioSourceList[index].tag.title
                                  .toString();
                        },
                        child: PodcastListTile(
                          podCast: podCast,
                          textColor: (accueilController.currentEmissionName.value
                              .contains(
                              '${accueilController.audioSourceList[index].tag.title}'))
                              ? Colors.white
                              : Colors.white,
                          styleContainer: BoxDecoration(
                            color: (accueilController.currentEmissionName.value
                                .contains(
                                '${accueilController.audioSourceList[index].tag.title}'))
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
        ));
  }
}
Widget myWave() {
  return
    Container(
      child: SizedBox(
        child: Lottie.asset('assets/wave.json'),
      ));
}
Widget lifeWord() {
  return Obx(() => accueilController.wordTextCoverLink.isNotEmpty
      ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✝️ Parole de Vie',
                style: AppText.h6.copyWith(fontWeight: FontWeight.bold),
              ),
              AppSizes.hGap5,
              Row(
                children: [
                  ThoughtCoover(
                      cover: accueilController.wordTextCoverLink.toString(),
                      contentList: accueilController.wordTextList)
                ],
              )
            ],
          ))
      : Container());
}

Widget ourReplay() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSizes.hGap15,
      Text(
        '🎧 Nos replay',
        style: AppText.h6.copyWith(fontWeight: FontWeight.bold),
      ),
      accueilController.tempoSpecialPodCastList.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: List<Widget>.generate(
                        accueilController.tempoSpecialPodCastList.length,
                        (index) {
                      var imageLink = accueilController
                          .tempoSpecialPodCastList[index].imagelink;
                      return ShowSpecialTile(
                        showSpecial:
                            accueilController.tempoSpecialPodCastList[index],
                        imageLink: imageLink,
                        onTap: () {
                          accueilController.resetPodcastList();
                          accueilController.isPodCastPlaying.value = false;
                          accueilController.updateFilteredShowSpecial(
                              accueilController
                                  .tempoSpecialPodCastList[index].id);
                          Get.to(() => ShowDetails(imageLink));
                        },
                      );
                    }),
                  )))
          : Container(),
    ],
  );
}

Widget pageTitle(String title, Color titleColor, double bottomValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
          padding: EdgeInsets.only(left: 10, bottom: bottomValue),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 35,
              fontFamily: "Segoe UI",
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          )),
    ],
  );
}
