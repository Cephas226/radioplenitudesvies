import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:radioplenitudesvie/models/pod_model.dart';
import 'package:radioplenitudesvie/models/torrent_cover_model.dart';
import 'package:radioplenitudesvie/pages/home/home_controller.dart';
import '../../consts/app_defaults.dart';
import '../../utils/ui_helper.dart';
import 'accueil_controller.dart';
import 'home_page.dart';
import 'hotcast.dart';
import 'podcast_tile.dart';

import '../../../consts/app_images.dart';
import '../../../consts/app_sizes.dart';
import '../../themes/text.dart';
import 'package:get/get.dart';

import 'show_title.dart';
import 'torrent_title.dart';

final AccueilController accueilController = Get.put(AccueilController());
final HomeController homeController = Get.put(HomeController());
final RxInt currentIndex = 0.obs;
final RxBool isPlaying = false.obs;
class ShowDetails extends StatelessWidget {
  String headerLink;
  ShowDetails(this.headerLink);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:
        Obx(() => Stack(
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
            Positioned(left: 0, right: 0, bottom: 5, child: ShowBannerPodcast(
                const Utf8Decoder()
                    .convert(accueilController.currentEmissionName.toString().codeUnits))):Container()
          ],
        ))
    );

  }

  Container myWave() {
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
              children: [Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 50,
                                width: double.maxFinite,
                                child: Lottie.asset('assets/wave.json'),
                              )))
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
