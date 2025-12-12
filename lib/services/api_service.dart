import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiService {
  String? token;

  ApiService({this.token});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    return json.decode(response.body);
  }

  Future<List<dynamic>> getNews() async {
    final response = await http.get(
      Uri.parse('$baseUrl/news'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> addComment(int newsId, String comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'news_id': newsId, 'content': comment}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> createNews(String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/news'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'title': title, 'content': content}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateNews(
    int id,
    String title,
    String content,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/news/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'title': title, 'content': content}),
    );
    return json.decode(response.body);
  }

  Future<bool> deleteNews(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/news/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
