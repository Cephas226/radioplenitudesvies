import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
final tpvPlayer = AudioPlayer();

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  static final _item = MediaItem(
    id: 'https://www.radioking.com/play/radioplenitudesvie',
    title: "Radio Plenitudes Vie",
    artUri: Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/radioplenitudesvie-dc905.appspot.com/o/forground.png?alt=media&token=5a6d5c29-6d64-4290-bbaa-3235a2a643c4'),
  );

  AudioPlayerHandler() {
    tpvPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.add(_item);
    tpvPlayer.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
  }

  @override
  Future<void> play() => tpvPlayer.play();

  @override
  Future<void> pause() => tpvPlayer.pause();

  @override
  Future<void> seek(Duration position) => tpvPlayer.seek(position);

  @override
  Future<void> stop() => tpvPlayer.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (tpvPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[tpvPlayer.processingState]!,
      playing: tpvPlayer.playing,
      updatePosition: tpvPlayer.position,
      bufferedPosition: tpvPlayer.bufferedPosition,
      speed: tpvPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}