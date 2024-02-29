class PodCast {
  final String name;
  final String id;
  final String link;
  PodCast({required this.name,this.id ="", required this.link});

  factory PodCast.fromJson(Map<String, dynamic> json) {
    return PodCast(
      name: json['name'] as String,
      id: json['id'] as String,
      link: json['link'] as String,
    );
  }
}
