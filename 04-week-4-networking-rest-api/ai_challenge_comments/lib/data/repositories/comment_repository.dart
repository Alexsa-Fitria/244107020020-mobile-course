import 'package:dio/dio.dart';
import '../models/comment.dart';

class CommentRepository {
  CommentRepository(this._dio);
  final Dio _dio;

  Future<List<Comment>> fetchComments(int postId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/comments',
        queryParameters: {'postId': postId},
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );
      final data = response.data ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(Comment.fromJson)
          .toList();
    } on DioException {
      rethrow; // Dilempar ke Notifier untuk ditangani
    }
  }
}