import 'package:sqflite/sqflite.dart';
import '../local/db.dart';
import '../local/post.dart';

class PostRepository {
  PostRepository({Future<Database> Function()? openDb})
      : _openDb = openDb ?? openNotesDb;

  final Future<Database> Function() _openDb;

  Future<List<Post>> readCachedPosts() async {
    final db = await _openDb();
    final rows = await db.query('cached_posts', orderBy: 'id ASC');
    return rows
        .map((r) => Post.fromPayload(r['id'] as int, r['payload'] as String))
        .toList();
  }

  Future<void> savePosts(List<Post> posts) async {
    final db = await _openDb();
    final batch = db.batch();
    for (final p in posts) {
      batch.insert(
        'cached_posts',
        {
          'id': p.id,
          'payload': p.encode(),
          'cached_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}