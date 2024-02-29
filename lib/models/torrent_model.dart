class Torrent {
  final int id;
  final String title;
  final String date;
  List<dynamic> daily_attachments;

  Torrent(
      {required this.id,
      required this.title,
      required this.daily_attachments,
      required this.date});

  factory Torrent.fromJson(Map<String, dynamic> json) {
    return Torrent(
      id: json['id'] as int,
      title: json['title'] as String,
      date: json['date'] as String,
      daily_attachments: json['daily_attachments'] as List<dynamic>,
    );
  }
}
