import 'package:get/get.dart';
import '../../models/station.dart';
import '../../provider/radio_service.dart';

class RadioController extends GetxController {
  final RadioService _radioService = RadioService();
  var selectedStation = Rx<Station?>(null);
  var isPlaying = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    selectedStation.value = Station(name: "Radio Plénitude de Vie", url: "https://www.radioking.com/play/radioplenitudesvie", genre: "Religieux");
    _radioService.playStation(Station(name: "Radio Plénitude de Vie", url: "https://www.radioking.com/play/radioplenitudesvie", genre: "Religieux"));
    isPlaying.value = false;
  }

  void playPause() {
    if (isPlaying.value) {
      _radioService.pause();
      isPlaying.value = false;
    } else {
      _radioService.resume();
      isPlaying.value = true;
    }
  }
  void stop() {
    _radioService.stop();
    isPlaying.value = false;
  }
  void pause() {
    _radioService.pause();
    isPlaying.value = false;
  }
  void play() {
    _radioService.pause();
    isPlaying.value = false;
  }
  @override
  void dispose() {
    _radioService.stop();
    super.dispose();
  }
  Station? get currentStation => _radioService.currentStation;
}
