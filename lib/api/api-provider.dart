import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:radioplenitudesvie/models/author.dart';
import 'package:radioplenitudesvie/models/pod_group_model.dart';
import 'package:radioplenitudesvie/models/show_special.dart';

import '../models/pod_model.dart';
import '../models/show.dart';
import '../utils/ui_helper.dart';

class RadioWebAPI {
  static var client = http.Client();

  static Future<List<dynamic>?> fetchPodCast(int month, int year) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/mois/$month/annee/$year'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["files"] as List<dynamic>;
    } else {
      return null;
    }
  }
 static Future<List<dynamic>> getFeedbackList() async {
    return await http.get(
    Uri.parse("https://script.google.com/macros/s/1zRAUid19tkySxx9vtfmU_2eJqOi1Ht-o4WjxMAnCo2ABezrX7bTycnhl/exec")).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback;
    });
  }
  static Future<List<dynamic>?> fetchPlanning() async {
    var response = await client.get(Uri.parse(
        'https://vpvitservice.pythonanywhere.com/programme/day/'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["files"] as List;
    } else {
      return null;
    }
  }
  static Future<List<dynamic>?> fetchAllShows(int month, int year) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/mois/$month/annee/$year'));
    var data = json.decode(response.body);
    if (data["files"] !=null) {
      return data["files"] as List<dynamic>;
    }
    else {
      var previous = month-1;
      var r = await client.get(Uri.parse(
          'http://vpvitservice.pythonanywhere.com/drivefiles/list/mois/$previous/annee/$year'));
      var data = json.decode(r.body);
     if (data["files"] !=null) {
        return data["files"] as List<dynamic>;
      }
    }
    return null;
  }
  static Future<List<PodCast>?> fetchAllSpecialShows(String year) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/speciale/annee/$year'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["files"] is List) {
        List<dynamic> tempSpecialShowData = data["files"] as List;
        List<dynamic> speaciaListTemp = [];
        List<PodCast> tempoSpecialPodCastList = [];

        for (dynamic item in tempSpecialShowData) {
          if (item is Map<String, dynamic>) {
            speaciaListTemp.add(item);
          }
        }
        for (dynamic auth in speaciaListTemp) {
          if (auth is Map<String, dynamic>) {
            Map<String, dynamic> mapItem2 = auth;

            mapItem2.forEach((key, value) {

              List<PodCast> showPodcast = (value as List<dynamic>).map((showPodCast) {
                return PodCast(
                    id:    showPodCast['id'] as String,
                    link:
                    showPodCast['link'] != null
                        ? showPodCast['link'] as String
                        : "",
                    imagelink: showPodCast['imagelink'] != null
                        ? showPodCast['imagelink'] as String
                        : "", name:key);
              }).toList();
              //ShowSpecial showSpecial = ShowSpecial(name: key, podCast: showPodcast);
              tempoSpecialPodCastList.addAll(showPodcast);

            });
          }
        }
        return tempoSpecialPodCastList;
      }
    }

    return null;
  }
  static Future<List<dynamic>?> fetchAllTargetedShows(String id) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/emissioncible/$id'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["files"] as List<dynamic>;
    } else {
      return null;
    }
  }
  static Future<List<dynamic>?> fetchAllAnnounces(int year) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/imagesannonces/annee/$year'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["files"] as List<dynamic>;
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> fetchAllTorrentPocket(int year) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/imagestorrentdevie/annee/$year'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["files"] as List<dynamic>;
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> fetchAllShowsPocket(int year) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/imagesemissions/annee/$year'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["files"] as List;
      var showList = <Show>[];
     /*
     for (dynamic show in data["files"]) {
        if (show is Map<String, dynamic>) {
          Map<String, dynamic> mapItem2 = show;
          String showName = mapItem2["name"].toString();
          String imagelink = mapItem2["imagelink"].toString();
          mapItem2.forEach((key, value) {
            Show s = Show(
                name: showName,
                imagelink: imagelink,
                key: basenameWithoutExtension(showName,
                ));
            bool showExists = showList.any((show) =>
            show.name == showName && show.imagelink == imagelink);
            if (!showExists) {
              showList.add(s);
            }
          });
        }
      }
      */
      return showList;
    } else {
      return null;
    }
  }

  static Future<List<Author>?> fetchAllSongAuthors() async {

    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/playlist'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["files"] is List) {
        List<dynamic> tempAuthorData = data["files"] as List;
        List<dynamic> authorListTemp = [];
        List<Author> authorList = [];

        for (dynamic item in tempAuthorData) {
          if (item is Map<String, dynamic>) {
            authorListTemp.add(item);
          }
        }
        for (dynamic auth in authorListTemp) {
          if (auth is Map<String, dynamic>) {
            Map<String, dynamic> mapItem2 = auth;
            mapItem2.forEach((key, value) {
              List<Author> songs = (value as List<dynamic>).map((songData) {
                return Author(
                  id: songData['id'] as String,
                  name: key,
                  link:
                  songData['link'] != null ? songData['link'] as String : "",
                  imagelink: songData['imagelink'] != null
                      ? songData['imagelink'] as String
                      : "",
                );
              }).toList();
              authorList.addAll(songs);
            });
          }
        }
        return authorList;
      }
    }

    return null;
  }
  static Future<List<dynamic>?> fetchAllTargetedSong(String id) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/singer/$id'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["files"] is List) {
        List<dynamic> singerData = data["files"] as List;
        List<PodCast> singerList = [];

        for (dynamic item in singerData) {
          if (item is Map<String, dynamic>) {
            PodCast singer = PodCast.fromJson(item);
            singerList.add(singer);
          }
        }
        return singerList;
      }
    }

    return null;
  }


}
