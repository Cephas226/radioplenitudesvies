import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:radioplenitudesvie/api/api-provider.dart';
import 'package:radioplenitudesvie/models/author.dart';
import 'package:radioplenitudesvie/models/pod_model.dart';
import 'package:radioplenitudesvie/models/show.dart';
import 'package:radioplenitudesvie/models/show_special.dart';

import '../../audio_helpers/audio_handler.dart';
import '../../models/torrent_pocket.dart';
import '../../utils/ui_helper.dart';
import 'package:http/http.dart' as http;

class AccueilController extends GetxController {
  var isLoading = false.obs;
  var isTorrentLoading = false.obs;
  var isPocketLoading = false.obs;
  var isShowLoading = false.obs;
  var isSpeacialShowLoading = true.obs;
  var isAnnounceLoading = false.obs;
  var isAuthorSongLoading = false.obs;
  RxInt currentYear = RxInt(DateTime.now().year);
  RxInt currentMonth = RxInt(DateTime.now().month);
  //var isPlaying = false.obs;
  var isPodCastPlaying = false.obs;
  var shouldScroll = false.obs;
  var metadata = <String>[].obs;
  var monthId = "".obs;
  var recentPodCastList = <dynamic>[].obs;
  var audioSourceList = <dynamic>[].obs;
  var audioPodSourceList = <dynamic>[].obs;
  var tempoPodCastList = <dynamic>[].obs;
  var planningItems = <dynamic>[].obs;
  var tempoSpecialPodCastList = <PodCast>[].obs;
  var torrentList = <dynamic>[].obs;
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
  var duration = ''.obs;
  var hopeWordCoverLink = ''.obs;
  var wordTextCoverLink = ''.obs;
  var position = ''.obs;
  var streamTitle = ''.obs;
  var currentValue = 0.0.obs;
  var currentEmissionName = ''.obs;
  var currentRadioName = ''.obs;
  RxInt randomNumber = 0.obs;
  var max = 0.0.obs;
  var currentDayIndex = DateTime.now().weekday;
  @override
  Future<void> onInit() async {
    super.onInit();
    fetchAllShowsPocket(currentYear.value);
    fetchAllAnnounces(currentYear.value);
    fetchAllShows(currentMonth.value, currentYear.value);
    fetchPlanning(currentDayIndex == 0 ?1 : currentDayIndex-1);
    songPlayRadio();
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
    currentIndex.value = index;
    isPodCastPlaying.value = true;
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
          duration.value = d.toString().split(".")[0];
          max.value = d.inSeconds.toDouble();
        }
      });
      tpvPlayer.positionStream.listen((p) {
        position.value = p.toString().split(".")[0];
        currentValue.value = p.inSeconds.toDouble();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> pause() async {
    await tpvPlayer.pause();
    //isPlaying.value = false;
  }

  Future<void> seekTo(Duration position) async {
    await tpvPlayer.seek(position);
  }

  Future<void> fetchAllShows(int month, int year) async {
    try {
      isShowLoading(true);
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
      checkForUpdate();
    }
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
    hopeWordCoverLink.value = filteredItem != null ? filteredItem['imagelink'].toString() : '';
  }

  filterCulteList(){
    final filteredItem = wordTextList[0];
    wordTextCoverLink.value = filteredItem != null ? filteredItem['imagelink'].toString() : '';
  }

  Future<void> fetchAllSpecialShows(String year) async {
    //isSpeacialShowLoading(true);
    try {
      var results = await RadioWebAPI.fetchAllSpecialShows(year);
      tempoSpecialPodCastList(results);
    } finally {
      isSpeacialShowLoading(false);
    }
  }

  Future<void> fetchAllAnnounces(int year) async {
    try {
      isAnnounceLoading(true);
      var results = await RadioWebAPI.fetchAllAnnounces(year);
      announceList(results);
    }
    catch (e){
      print('Error while getting data is $e');
    }
    finally {
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

  String getSelectedDay(int currentDayIndex) {
    List<String> frenchDays = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"];
    return frenchDays[currentDayIndex-1];
  }

  void fetchPlanning(currentDayIndex) async {
    var index = currentDayIndex== 0 ?1 : currentDayIndex-1;
    print('*****'+index.toString()+"*****");
    var results = await RadioWebAPI.fetchPlanning();
    var header = results![0] as List;
    Map<String, dynamic> itemsList = {};
    for (int i =1; i<results.length; i++){
      var rows = results[i] as List;
      var cols = [];
      for (int j =1; j<rows.length; j++){
        cols.add(rows[j]);
      }
      itemsList[rows[0].toString()] = cols;
    }
    for (int k =1; k<header.length; k++){
      if(k==index){
        itemsList.forEach((key, value) {
          planningItems.add({
            "hour": key,
            "emission": value[k],
          });
        });
      }
    }
    update();
  }

  Future<void> fetchAllShowsPocket(int year) async {
    try {
      isPocketLoading(true);
      var results = await RadioWebAPI.fetchAllShowsPocket(year);
      await Future.wait(results!.map((show) async {
        if (show is Map<String, dynamic>) {
          Map<String, dynamic> mapItem2 = show;
          String showName = mapItem2["name"].toString();
          String imagelink = mapItem2["imagelink"].toString();

          Show s = Show(
            name: showName,
            imagelink: imagelink,
            key: basenameWithoutExtension(showName),
          );

          bool showExists = showList.any((show) =>
          show.name == showName && show.imagelink == imagelink);

          if (!showExists) {
            showList.add(s);
          }
        }
      }));
    } catch (e) {
      print('Error while getting data is $e');
    } finally {
      isPocketLoading(false);
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
    }
  }

  Future<void> updateFilteredTargetedSongString(String filterKey) async {
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
    }
  }

  resetPodcastList() {
    podCastsList.clear();
  }

}
