class TorrentCover {
  final int id;
  final String cover;

  TorrentCover({required this.id, required this.cover});

  factory TorrentCover.fromJson(Map<String, dynamic> json) {
    return TorrentCover(
      id: json['id'] as int,
      cover: json['cover'] as String,
    );
  }
}
