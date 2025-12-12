import 'user.dart';

class Comment {
  final int id;
  final String content; // <-- ganti
  final User user;

  Comment({required this.id, required this.content, required this.user});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'], // <-- ganti
      user: User.fromJson(json['user']),
    );
  }
}
