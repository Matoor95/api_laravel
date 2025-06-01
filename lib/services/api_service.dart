import 'dart:convert';

import 'package:api_laravel/models/article.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://apilaravel.test/api/articles';

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((data) => Article.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des donnes');
    }
  }
}
