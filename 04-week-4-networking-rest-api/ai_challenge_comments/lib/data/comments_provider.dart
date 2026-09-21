import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'models/comment.dart';
import 'repositories/comment_repository.dart';
import 'providers.dart';

// Provider untuk CommentRepository
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository(ref.watch(dioProvider));
});

// AsyncNotifier untuk Comments
class CommentsNotifier extends AsyncNotifier<List<Comment>> {
  @override
  Future<List<Comment>> build() async {
    // Secara default, kita butuh postId. Kita bisa set default 1.
    return _fetchComments(1);
  }

  Future<List<Comment>> _fetchComments(int postId) async {
    final repository = ref.read(commentRepositoryProvider);
    return repository.fetchComments(postId);
  }

  // Fungsi untuk memuat ulang dengan postId tertentu
  Future<void> loadComments(int postId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchComments(postId));
  }
}

final commentsProvider =
    AsyncNotifierProvider<CommentsNotifier, List<Comment>>(
  CommentsNotifier.new,
);

// Fungsi pesan error ramah pengguna
String friendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi lambat atau timeout. Periksa internet Anda lalu coba lagi.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa internet Anda.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 404) return 'Data tidak ditemukan (404).';
        if (code == 500) return 'Server bermasalah (500). Coba lagi nanti.';
        return 'Server bermasalah ($code). Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan jaringan. Coba lagi.';
    }
  }
  return 'Terjadi kesalahan tak terduga: $error';
}