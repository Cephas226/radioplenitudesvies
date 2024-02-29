import 'package:get/get.dart';

import '../../api/api-provider.dart';
import '../../models/author.dart';

class PlayLlistScreenController extends GetxController {

  var isAuthorSongLoading = false.obs;
  var authorList = <Author>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllSongAuthors();
  }
  Future<void> fetchAllSongAuthors() async {
    try {
      isAuthorSongLoading(true);
      var results = await RadioWebAPI.fetchAllSongAuthors();
      authorList(results);
    } finally {
      isAuthorSongLoading(false);
    }
  }

}
