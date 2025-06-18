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

//function pour ajouter des articles
  Future<bool> addArticle(String titre, String contenu) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'titre': titre, 'contenu': contenu}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Échec du serveur: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur réseau: $e');
      return false;
    }
  }
//function update
  Future<bool> updateArticle(int id, String titre, String contenu) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'titre': titre, 'contenu': contenu}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur update: $e');
      return false;
    }
  }
//function delete
  Future<bool> deleteArticle(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      return response.statusCode == 204;
    } catch (e) {
      print('Erreur suppression: $e');
      return false;
    }
  }
}
