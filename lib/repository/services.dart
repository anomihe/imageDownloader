import 'dart:convert';
import 'dart:io';


import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import '../models/data_model.dart';

class ApiCallRepo {
  static Future<List<PictureModel>> fetchData() async {
    const picsUrl = 'https://picsum.photos/v2/list';
    final picClient = http.Client();
    List<PictureModel> pics = [];
    try {
      http.Response response = await picClient.get(Uri.parse(picsUrl));
      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        PictureModel pic =
            PictureModel.fromJson(result[i] as Map<String, dynamic>);
        pics.add(pic);
      }
      return pics;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<void> downloadImage(String link) async {
    FlutterDownloader.enqueue(
      url: link, savedDir: '/storage/emulated/0/Download/',
    
      saveInPublicStorage: true,
    );
    
  }
}
