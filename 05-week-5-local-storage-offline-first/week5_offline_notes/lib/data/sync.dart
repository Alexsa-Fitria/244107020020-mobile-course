import 'package:dio/dio.dart';
import 'local/post.dart';
import 'repositories/note_repository.dart';
import 'repositories/post_repository.dart';

final _dio = Dio(BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 5),
));

/// 1. CACHE-FIRST READ
/// Tampilkan cache lokal seketika, lalu refresh dari network di background.
Future<List<Post>> loadPostsCacheFirst({
  required PostRepository postRepo,
  void Function()? onRefreshed,
}) async {
  final cached = await postRepo.readCachedPosts();
  _refreshPostsInBackground(postRepo: postRepo, onRefreshed: onRefreshed);
  return cached;
}

Future<void> _refreshPostsInBackground({
  required PostRepository postRepo,
  void Function()? onRefreshed,
}) async {
  try {
    final res = await _dio.get('/posts');
    final posts = (res.data as List)
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
    await postRepo.savePosts(posts);
    onRefreshed?.call();
  } catch (_) {
    // Offline / network error: cukup diamkan, cache tetap dipakai.
  }
}

/// 2. SINKRONISASI CATATAN KOTOR (dirty)
/// Simulasi upload ke server — belum ada backend tulis.
Future<int> syncNotes(NoteRepository repo) async {
  final dirtyCount = await repo.countDirty();
  if (dirtyCount == 0) return 0;

  // Simulasi upload: pada project nyata, kirim tiap catatan dirty
  // ke REST API di sini, lalu tandai bersih bila server menjawab 2xx.
  await Future.delayed(const Duration(seconds: 1));
  await repo.markAllSynced();
  return dirtyCount;
}