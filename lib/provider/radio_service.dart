import 'package:audioplayers/audioplayers.dart';

import '../models/station.dart';

class RadioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Station? _currentStation;

  Future<void> playStation(Station station) async {
    if (_currentStation != null) {
      await _audioPlayer.stop();
    }

    _currentStation = station;
    await _audioPlayer.play(UrlSource(station.url));
  }

  Future<void> pause () async{
    if(_audioPlayer.state == PlayerState.playing){
      await _audioPlayer.pause();
    }
  }

  Future<void> resume () async{
    if(_audioPlayer.state == PlayerState.paused){
      await _audioPlayer.resume();
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentStation = null;
  }

  Station? get currentStation => _currentStation;
}
