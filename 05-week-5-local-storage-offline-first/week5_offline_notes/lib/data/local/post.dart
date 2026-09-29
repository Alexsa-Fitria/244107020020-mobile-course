import 'dart:convert';

class Post {
  const Post({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
      };

  String encode() => jsonEncode(toJson());

  factory Post.fromPayload(int id, String payload) =>
      Post.fromJson(jsonDecode(payload) as Map<String, dynamic>);
}