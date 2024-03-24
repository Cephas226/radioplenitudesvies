import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radioplenitudesvie/models/pod_model.dart';
import 'package:radioplenitudesvie/models/torrent_model.dart';

class RadioWebService {
  static var client = http.Client();

  static Future<List<Torrent>?> fetchDataFromApI() async {
    var response = await client.get(Uri.parse(
        'https://vpvitservice.pythonanywhere.com/daily-torrent/create/'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return (jsonData as List)
          .map((e) => Torrent.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      return null;
    }
  }

  static Future<List<PodCast>?> fetchPodCast(String month) async {
    var response = await client.get(Uri.parse(
        'https://vpvitservice.pythonanywhere.com/drivefiles/list/$month'));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['files'] is List) {
        var filesList = jsonData['files'] as List;

        return filesList
            .map((e) => PodCast.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<PodCast>?> fetchCurrentPodCast() async {
    var response = await client.get(Uri.parse(
        'https://vpvitservice.pythonanywhere.com/drivefiles/list/annee/1Pxa4p8wNZVHpFTiddtlwYDsvWUPkyBB5'));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData != null && jsonData['files'] is List) {
        var filesList = jsonData['files'] as List;
        return filesList
            .map((e) => PodCast.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> fetchAllPodCast(int month, int year) async {
    var response = await client.get(Uri.parse(
        'http://vpvitservice.pythonanywhere.com/drivefiles/list/mois/$month/annee/$year'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["files"] as List;
    } else {
      return null;
    }
  }

  static Future<dynamic> fetchPodCastPerMonth(
      String monthYear, String selectedYear) async {
    var selectedMonth = monthYear + selectedYear.toString();
    var response = await client.get(Uri.parse(
        'https://vpvitservice.pythonanywhere.com/drivefiles/list/annee/$selectedYear'));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData != null && jsonData['files'] is List) {
        var filesList = jsonData['files'] as List;
        var filteredFiles = filesList
            .where((e) => e['name'] == selectedMonth.toUpperCase())
            .toList();

        if (filteredFiles.isNotEmpty) {
          return filteredFiles[0]['id'];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
