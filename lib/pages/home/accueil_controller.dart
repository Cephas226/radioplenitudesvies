import 'dart:math';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:radio_player/radio_player.dart';
import 'package:radioplenitudesvie/api/api-provider.dart';
import 'package:radioplenitudesvie/models/author.dart';
import 'package:radioplenitudesvie/models/pod_model.dart';
import 'package:radioplenitudesvie/models/show.dart';

import '../../audio_helpers/audio_handler.dart';
import '../../consts/app_images.dart';
import '../../utils/ui_helper.dart';

class AccueilController extends GetxController {
  var isLoading = false.obs;
  var isTorrentLoading = false.obs;
  var isPocketLoading = false.obs;
  var isShowLoading = false.obs;
  var isSpeacialShowLoading = false.obs;
  var isAnnounceLoading = false.obs;
  var isAuthorSongLoading = false.obs;
  RxInt currentYear = RxInt(DateTime.now().year);
  RxInt currentMonth = RxInt(DateTime.now().month);
  var isPodCastPlaying = false.obs;
  var isShowingPlyWidget = false.obs;
  var shouldScroll = false.obs;
  var showMyWave = false.obs;
  var metadata = <String>[].obs;
  var monthId = "".obs;
  var recentPodCastList = <dynamic>[].obs;
  var audioSourceList = <dynamic>[].obs;
  var audioPodSourceList = <dynamic>[].obs;
  var tempoPodCastList = <dynamic>[].obs;
  var tempoSpecialPodCastList = <PodCast>[].obs;
  var torrentList = <dynamic>[].obs;
  var authorList = <Author>[].obs;
  var specialPodCastList = <dynamic>[].obs;
  var podCastsList = <dynamic>[].obs;
  var showList = <Show>[].obs;
  var announceList = [].obs;
  var adsList = <Show>[].obs;
  var tempList = <dynamic>[].obs;
  var hopeWordList = <dynamic>[].obs;
  var wordTextList = <dynamic>[].obs;
  var adsTempList = <dynamic>[].obs;
  var currentIndex = 0.obs;

  var hopeWordCoverLink = ''.obs;
  var wordTextCoverLink = ''.obs;
  Rx<Duration> duration =  const Duration(seconds: 0).obs;
  Rx<Duration> position =  const Duration(seconds: 0).obs;

  var streamTitle = ''.obs;
  var currentValue = 0.0.obs;
  var currentEmissionName = ''.obs;
  var currentRadioName = ''.obs;
  RxInt randomNumber = 0.obs;
  var max = 0.0.obs;

  final RadioPlayer radioPlayer = RadioPlayer();
  RxBool isPlaying = false.obs;
  var metadataverse = <String>[].obs;

  Rx<Color> buttonColor = const Color(0xFF1C1B1B).obs; // Couleur initiale


  @override
  Future<void> onInit() async {
    super.onInit();
    refreshList();
  }
  void initRadioPlayer() {
    radioPlayer.setChannel(
      title: 'Radio Player',
      url: 'https://www.radioking.com/play/radioplenitudesvie',
      imagePath: AppImages.PLAYER,
    );

    radioPlayer.stateStream.listen((value) {
      isPlaying.value = value;
    });

    radioPlayer.metadataStream.listen((value) {
      metadataverse.value = value;
    });
  }

  Future<void> refreshList() async{
    fetchAllAnnounces(currentYear.value);
    fetchAllShows(currentMonth.value, currentYear.value);
    fetchAllSpecialShows(currentYear.value.toString());
    fetchAllShowsPocket(currentYear.value);
    fetchAllSongAuthors();
    fetchAllTorrent(currentYear.value);
    Future.delayed(const Duration(seconds: 5), () {
      songPlayRadio();
    });
    Future.delayed(const Duration(minutes: 1), () {
      checkForUpdate();
    });
  }
  void getRandomeNumber() {
    randomNumber.value = Random().nextInt(7);
  }

  @override
  void dispose() {
    tpvPlayer.dispose();
    super.dispose();
  }

  void songPlayPodCast(String uri, int index, String title) {
    print('$uri$title');
    currentIndex.value = index;
    isPodCastPlaying.value = true;
    isShowingPlyWidget.value = true;
    currentEmissionName.value = title;

    try {
      tpvPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri),
          tag: MediaItem(
            id: uri,
            title: currentEmissionName.value,
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/radioplenitudesvie-dc905.appspot.com/o/forground.png?alt=media&token=5a6d5c29-6d64-4290-bbaa-3235a2a643c4'),
          ),
        ),
      );
      updatePosition();
      tpvPlayer.play();
      getRandomeNumber();
    } catch (e) {
      print(e);
    }
  }

  Future<void> songPlayRadio() async {
    print("****Radio*****");
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    isPodCastPlaying.value = false;
    tpvPlayer.playbackEventStream.listen((event) {
      if (event.icyMetadata?.info != null) {
        streamTitle.value = event.icyMetadata!.info!.title.toString();
        currentRadioName.value = streamTitle.value;
      }
    }, onError: (Object e, StackTrace stackTrace) {});
    try {
      tpvPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse("https://www.radioking.com/play/radioplenitudesvie"),
          tag: MediaItem(
            id: "1",
            title: 't',
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/radioplenitudesvie-dc905.appspot.com/o/forground.png?alt=media&token=5a6d5c29-6d64-4290-bbaa-3235a2a643c4'),
          ),
        ),
      );
      updatePosition();
      tpvPlayer.play();
      getRandomeNumber();
    } catch (e) {
      print(e);
    }
  }

  updatePosition() {
    try {
      tpvPlayer.durationStream.listen((d) {
        if (d != null) {
          duration.value = d;
          max.value = d.inSeconds.toDouble();
        }
      });
      tpvPlayer.positionStream.listen((p) {
        position.value = p;
        currentValue.value = p.inSeconds.toDouble();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> pause() async {
    await tpvPlayer.pause();
  }
  Future<void> stop() async {
    await tpvPlayer.stop();
  }
  void next() {
    if (currentIndex.value + 1 != 6) {
      currentIndex.value++;
      ProgressiveAudioSource pdcst = audioSourceList[currentIndex.value] as ProgressiveAudioSource;
      songPlayPodCast(pdcst.uri.toString(),currentIndex.value,pdcst.tag.title.toString());
    }
  }

  void back() {
    print("back");
    if (currentIndex.value - 1 != -1) currentIndex.value--;
    ProgressiveAudioSource pdcst = audioSourceList[currentIndex.value] as ProgressiveAudioSource;
    songPlayPodCast(pdcst.uri.toString(),currentIndex.value,pdcst.tag.title.toString());
  }

  Future<void> seekTo(Duration position) async {
    await tpvPlayer.seek(position);
  }
  set setPositionValue(double value)  {
    tpvPlayer.seek(Duration(seconds: value.toInt()));
  }
  Future<void> fetchAllShows(int month, int year) async {
    isShowLoading(true);
    try {
      var results = await RadioWebAPI.fetchAllShows(month, year);
      tempoPodCastList(results);
      if (results != null) {
        await Future.wait(results.map((item) async {
          if (item is Map<String, dynamic>) {
            Map<String, dynamic> mapItem1 = item;

            mapItem1.forEach((key, value) {
              const buildTempList = ["TDL","ME","IM","DS","DPP","DM"];
              if (buildTempList.contains(key)) {
                tempList(value as List);
              }
              if (key == "PE") {
                hopeWordList(value as List);
              }
              if (key == "CULTE") {
                wordTextList(value as List);
              }
            });
          }

          for (dynamic show in tempList) {
            if (show is Map<String, dynamic>) {
              Map<String, dynamic> mapItem2 = show;
              String showName = mapItem2["name"].toString();
              String link = mapItem2["link"].toString();
              if (AppUiHelper().fileExention(showName.toLowerCase()).contains("mp3")) {
                bool podcastExists = recentPodCastList.any((podcast) =>
                podcast['name'] == showName && podcast['link'] == link);

                if (!podcastExists) {
                  recentPodCastList.add(mapItem2);
                }
              }
            }
          }
        }));

        List<AudioSource> audioSources = recentPodCastList.map((audio) {
          return AudioSource.uri(
            Uri.parse(audio['link'].toString()),
            tag: MediaItem(
              id: audio['name'].toString(),
              title: audio['name'].toString(),
            ),
          );
        }).toList();
        audioSourceList.assignAll(audioSources);
        filterHopeWordList();
        filterCulteList();
      }
    } finally {
      isShowLoading(false);
    }
  }

  Future<void> fetchAllSpecialShows(String year) async {
    isSpeacialShowLoading(true);
    try {
      var results = await RadioWebAPI.fetchAllSpecialShows(year);
      tempoSpecialPodCastList(results);
    } finally {
      isSpeacialShowLoading(false);
    }
  }

  Future<void> fetchAllAnnounces(int year) async {
    isAnnounceLoading(true);
    try {
      var results = await RadioWebAPI.fetchAllAnnounces(year);
      announceList(results);
    } finally {
      isAnnounceLoading(false);
    }
  }

  Future<void> fetchAllTorrent(int year) async {
    isTorrentLoading(true);
    try {
      var results = await RadioWebAPI.fetchAllTorrentPocket(year);
      torrentList(results);
    } finally {
      isTorrentLoading(false);
    }
  }

  Future<void> fetchAllShowsPocket(int year) async {
    isPocketLoading(true);
    try {
      var results = await RadioWebAPI.fetchAllShowsPocket(year);
      showList(results);
    } finally {
      isPocketLoading(false);
    }
  }

  Future<void> fetchAllSongAuthors() async {
    try {
      var results = await RadioWebAPI.fetchAllSongAuthors();
      authorList(results);
    } finally {
      isAuthorSongLoading(false);
    }
  }

  Future<void> updateFilteredShows(String filterKey) async {
    var tempoValue = <dynamic>[];
    for (dynamic item in tempoPodCastList) {
      if (item is Map<String, dynamic>) {
        Map<String, dynamic> mapItem = item;
        mapItem.forEach((key, value) {
          if (key == filterKey) {
            if (value is List<dynamic>) {
              var filteredList = value.where((item) => AppUiHelper()
                  .fileExention(item['name'].toString().toLowerCase())
                  .contains("mp3"));
              tempoValue.addAll(filteredList);
              podCastsList(tempoValue);
              update();
            }
          }
        });
      }
      List<AudioSource> audioSources = podCastsList.map((audio) {
        return AudioSource.uri(
          Uri.parse(audio['link'].toString()),
          tag: MediaItem(
            id: audio['name'].toString(),
            title: audio['name'].toString(),
          ),
        );
      }).toList();
      audioPodSourceList.assignAll(audioSources);
    }
  }

  Future<void> updateFilteredShowSpecial(String filterKey) async {
    isLoading(true);
    try {
      var results = await RadioWebAPI.fetchAllTargetedShows(filterKey);
      podCastsList(results);
      List<AudioSource> audioSources = podCastsList.map((audio) {
        return AudioSource.uri(
          Uri.parse(audio['link'].toString()),
          tag: MediaItem(
            id: audio['name'].toString(),
            title: audio['name'].toString(),
          ),
        );
      }).toList();
      audioPodSourceList.assignAll(audioSources);
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateFilteredTargetedSongString(String filterKey) async {
    isLoading(true);
    try {
      podCastsList.clear();
      var results = await RadioWebAPI.fetchAllTargetedSong(filterKey);
      podCastsList(results);
      List<AudioSource> audioSources = podCastsList.map((audio) {
        return AudioSource.uri(
          Uri.parse('${audio.link}'),
          tag: MediaItem(
            id: '${audio.name}',
            title: '${audio.name}',
          ),
        );
      }).toList();
      audioPodSourceList.assignAll(audioSources);
      update();
    } finally {
      isLoading(false);
    }
  }

  resetPodcastList() {
    podCastsList.clear();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              InAppUpdate.performImmediateUpdate();
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }
  filterHopeWordList(){
    final filteredItem = hopeWordList.firstWhere(
          (hopeWord) => hopeWord['imagelink'] != null,
      orElse: () => null,
    );

    hopeWordCoverLink.value =
    filteredItem != null ? filteredItem['imagelink'].toString() : '';
  }
  filterCulteList(){
    final filteredItem = wordTextList[0];
    wordTextCoverLink.value =
    filteredItem != null ? filteredItem['imagelink'].toString() : '';
  }
  String formattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
  void toggleColor() {
    buttonColor.value = buttonColor.value == const Color(0xFF1C1B1B) ? Colors.white : const Color(0xFF1C1B1B);
  }
}
