import 'user.dart';
import 'comment.dart';

class News {
  final int id;
  final String title;
  final String content;
  final User user;
  final List<Comment> comments;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.user,
    required this.comments,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      user: User.fromJson(json['user']),
      comments: (json['comments'] as List)
          .map((c) => Comment.fromJson(c))
          .toList(),
    );
  }
}
