import 'package:flutter/material.dart';
import '../models/news.dart';
import '../constants.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsDetailScreen extends StatefulWidget {
  final int newsId;
  final ApiService apiService;

  const NewsDetailScreen({
    Key? key,
    required this.newsId,
    required this.apiService,
  }) : super(key: key);

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  News? news;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse("$baseUrl/news/${widget.newsId}"),
      headers: {"Authorization": "Bearer ${widget.apiService.token}"},
    );

    if (response.statusCode == 200) {
      setState(() {
        news = News.fromJson(json.decode(response.body));
        isLoading = false;
      });
    }
  }

  void addComment() {
    final commentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Komentar"),
        content: TextField(
          controller: commentCtrl,
          decoration: const InputDecoration(hintText: "Tulis komentar..."),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final text = commentCtrl.text.trim();
              if (text.isEmpty) return;

              await widget.apiService.addComment(widget.newsId, text);

              Navigator.pop(context);
              fetchNews();
            },
            child: const Text("Kirim"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (news == null) {
      return const Scaffold(
        body: Center(child: Text("Berita tidak ditemukan")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(news!.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: addComment,
        child: const Icon(Icons.add_comment),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news!.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            const Text(
              "Semua Komentar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: news!.comments.length,
                itemBuilder: (context, index) {
                  final c = news!.comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(c.user.name[0].toUpperCase()),
                    ),
                    title: Text(c.user.name),
                    subtitle: Text(c.content),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
