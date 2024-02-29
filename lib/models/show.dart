class Show {
  String name;
  String imagelink;
  String key;
  Show(
      {required this.name, this.imagelink = "", required this.key});

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      name: json['name'] as String,
      key: json['key'] as String,
      imagelink: json['imagelink'] == null ? "" : json['imagelink'] as String,
    );
  }
}
