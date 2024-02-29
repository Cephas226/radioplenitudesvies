class PodCast {
  final String name;
  final String id;
  final String link;
  final String imagelink;
  PodCast({required this.name, required this.link,required this.imagelink,this.id=""});

  factory PodCast.fromJson(Map<String, dynamic> json) {
    return PodCast(
      name: json['name'] as String,
      link: json['link'] !=null ? json['link'] as String:"",
      id: json['id'] !=null ? json['id'] as String:"",
      imagelink: json['imagelink'] !=null ? json['imagelink'] as String:"",
    );
  }
}
