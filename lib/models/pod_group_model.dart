class PodcastGroup {
  final String groupName;
  final List<Podcast> podcasts;

  PodcastGroup(this.groupName, this.podcasts);
}

class Podcast {
  final String name;
  final String link;

  Podcast(this.name, this.link);
}
