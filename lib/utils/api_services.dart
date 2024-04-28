import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pixagallery/env.dart';
import 'package:pixagallery/models/image_model.dart';

class ApiService {
  static const String _baseUrl = 'https://pixabay.com/api/';

  Future<List<ImageModel>> fetchImages(
      {int page = 1, String query = ''}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl?key=$EnvService.myKey&q=$query&page=$page&per_page=20'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['hits'];
      return data.map<ImageModel>((item) => ImageModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
