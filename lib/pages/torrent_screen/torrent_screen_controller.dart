import 'package:get/get.dart';
import 'package:radioplenitudesvie/api/radio_web_service.dart';
import 'package:radioplenitudesvie/models/torrent_model.dart';

class TorrentScreenController extends GetxController {
  var torrents = <Torrent>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTorrents(DateTime.now().toString().split(' ')[0]);
  }

  void fetchTorrents(selectedDate) async {
    isLoading(true);
    try {
      isLoading(true);
      var articleTemp = await RadioWebService.fetchTorrents();
      if (articleTemp != null) {
        torrents(articleTemp
            .where((torrent) => torrent.date == selectedDate.toString())
            .toList());
      }
    } finally {
      isLoading(false);
    }
  }
}