import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../home/home_page.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  static String apiKey = "AIzaSyA9uZdqFNkoL780RI_07qEqN4YbNxfwTY0";
  YoutubeAPI youtubeAPI = YoutubeAPI(apiKey, maxResults: 50);

  late List<YouTubeVideo> videosList = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  _fetchVideos() async {
   videosList = await youtubeAPI.channel("UCWzTYIc-h8DPT3lKB8CyEVQ");
    setState(() {});
  }

  String formattedDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat.yMMMMEEEEd().format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            pageTitle("Cultes", Colors.black,20,Container(child: Container())),
            CarouselSlider.builder(
              itemCount: videosList.length > 5 ? 5 : videosList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                String videoId = videosList[index].id.toString();
                String videoThumbnailUrl =
                    videosList[index].thumbnail.medium.url.toString();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          videoId: videoId,
                          title: videosList[index].title.toString(),
                          description: videosList[index].description.toString(),
                        ),
                      ),
                    );
                  },
                  child:
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child:
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: videoThumbnailUrl,
                          placeholder: (context, url) => const SpinKitThreeBounce(
                            color: Colors.redAccent,
                            size: 50.0,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                    ),
                  ),
                );
              },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 10,
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height / 5.5,
                )
            ),
            videosList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                    itemCount: videosList.length,
                    itemBuilder: (context, i) {
                      String videoId = videosList[i].id.toString();
                      String videoThumbnailUrl =
                          videosList[i].thumbnail.medium.url.toString();

                      return Column(
                        children: [
                          ListTile(
                              onTap: () {
                                Get.to(VideoPlayerScreen(
                                    videoId: videoId,
                                    title:
                                    videosList[i].title.toString(),
                                    description:
                                        videosList[i].description.toString()));
                              },
                              leading: Image.network(videoThumbnailUrl),
                              title: Text(videosList[i].title),
                              subtitle: Text(formattedDate(
                                  videosList[i].publishedAt.toString()))),
                          const SizedBox(height: 5)
                        ],
                      );
                    },
                  ))
                : const Center(
                    child: SpinKitThreeBounce(
                    color: Color.fromARGB(255, 63, 35, 1),
                    size: 50.0,
                  )),
          ],
        ));
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;
  final String description;
  final String title;
  const VideoPlayerScreen(
      {super.key,
      required this.videoId,
      required this.description,
      required this.title});

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Text(title.isNotEmpty ? title.toString() : "",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
      body: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              YoutubePlayer(controller: controller),
              Text(
                description,
                maxLines: 10,
              ),
            ],
          )),
    );
  }
}
