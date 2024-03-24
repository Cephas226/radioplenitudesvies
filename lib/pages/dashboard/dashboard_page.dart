import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radioplenitudesvie/pages/bible_screen/bible_screen.dart';
import 'package:radioplenitudesvie/pages/video_screen/video_screen_view.dart';
import 'package:radioplenitudesvie/pages/torrent_screen/torrent_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../home/accueil_controller.dart';
import '../home/home_page.dart';
import '../play_list_screen/play_list_view.dart';
import 'dashboard_controller.dart';

final AccueilController accueilController = Get.put(AccueilController());

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Obx(() => Skeletonizer(
                enabled: accueilController.isAnnounceLoading.value,
                child: Stack(children: [
                  SafeArea(
                    child: IndexedStack(
                      index: controller.tabIndex.value,
                      children: [
                          HomeScreen(),
                        TorrentScreenView(
                            selectedDate: DateTime.now(),
                            lastDate: DateTime.now()),
                        const BibleScreenView(),
                        const PlayLlistScreenView(),
                        const VideoListScreen(),
                      ],
                    ),
                  ),
                  accueilController.isPodCastPlaying.value
                      ? Positioned(
                          left: 0,
                          right: 0,
                          bottom: 2,
                          child: showBannerPodcast(const Utf8Decoder().convert(
                              accueilController.currentEmissionName
                                  .toString()
                                  .codeUnits),context))
                      : Positioned(
                          left: 0,
                          right: 0,
                          bottom: 2,
                          child: showBannerPodcast(
                              accueilController.currentRadioName.toString(),context)),
                ]))),
            bottomNavigationBar: BottomNavyBar(
                selectedIndex: controller.tabIndex.value,
                onItemSelected: controller.changeTabIndex,
                items: <BottomNavyBarItem>[
                  BottomNavyBarItem(
                    icon: const Icon(Icons.home),
                    title: const Text('Home'),
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                  BottomNavyBarItem(
                    icon: const Icon(Icons.calendar_today),
                    title: const Text('Torrent de Vie'),
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                  BottomNavyBarItem(
                    icon: const Icon(Icons.web_stories),
                    title: const Text('Bible'),
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                  BottomNavyBarItem(
                    icon: const Icon(Icons.queue_music_rounded),
                    title: const Text('Playlist'),
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                  BottomNavyBarItem(
                    icon: const Icon(Icons.video_camera_back_rounded),
                    title: const Text('Video'),
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                ]));
      },
    );
  }
}
