class ProgressiveAudioModel {
  final Uri uri;
  final Map<String, String>? headers;
  final dynamic tag;
  final Duration? duration;
  final dynamic options;

  ProgressiveAudioModel({
    required this.uri,
    this.headers,
    this.tag,
    this.duration,
    this.options,
  });
}