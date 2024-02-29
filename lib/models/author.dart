
class Author {
  final String name;
  final String link;
  final String imagelink;
  final String id;

  Author({
    required this.name,
    required this.id,
    required this.link,
    this.imagelink = "",
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] != null ? json['name'] as String : "",
      id: json['id'] != null ? json['id'] as String : "",
      link: json['link'] != null ? json['link'] as String : "",
      imagelink: json['imagelink'] != null ? json['imagelink'] as String : "",
    );
  }
}
