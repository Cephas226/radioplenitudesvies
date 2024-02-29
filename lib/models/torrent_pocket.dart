
class TorrentPocket {
  final String name;
  final String imagelink;

  TorrentPocket({
    required this.name,
    this.imagelink = "",
  });

  factory TorrentPocket.fromJson(Map<String, dynamic> json) {
    return TorrentPocket(
      name: json['name'] != null ? json['name'] as String : "",
      imagelink: json['imagelink'] != null ? json['imagelink'] as String : "",
    );
  }
}
