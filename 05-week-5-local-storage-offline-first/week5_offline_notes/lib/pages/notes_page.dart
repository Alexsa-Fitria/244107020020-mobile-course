import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';
import '../data/repositories/post_repository.dart';
import '../data/sync.dart';

// ============ PROVIDERS ============
final noteRepositoryProvider =
    Provider<NoteRepository>((ref) => NoteRepository());

final postRepositoryProvider =
    Provider<PostRepository>((ref) => PostRepository());

final notesProvider =
    AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

final dirtyCountProvider = FutureProvider<int>((ref) async {
  // Auto-refresh saat notesProvider di-invalidate
  ref.watch(notesProvider);
  return ref.read(noteRepositoryProvider).countDirty();
});

// ============ NOTIFIER ============
class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() {
    return ref.watch(noteRepositoryProvider).fetchNotes();
  }

  Future<void> add(String title, String body) async {
    await ref.read(noteRepositoryProvider).addNote(title: title, body: body);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(int id) async {
    await ref.read(noteRepositoryProvider).deleteNote(id);
    ref.invalidateSelf();
    await future;
  }
}

// ============ HALAMAN ============
class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final dirtyAsync = ref.watch(dirtyCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Offline'),
        actions: [
          // Badge Dirty
          dirtyAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (count) {
              if (count == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text('Dirty: $count'),
                  backgroundColor: Colors.orange.shade200,
                ),
              );
            },
          ),
          // Tombol Sync
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Sync catatan',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final repo = ref.read(noteRepositoryProvider);
              final synced = await syncNotes(repo);

              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    synced == 0
                        ? 'Tidak ada yang perlu di-sync'
                        : '$synced catatan ter-sync',
                  ),
                ),
              );

              // Refresh daftar + badge
              ref.invalidate(notesProvider);
              ref.invalidate(dirtyCountProvider);
            },
          ),
        ],
      ),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $e', textAlign: TextAlign.center),
          ),
        ),
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text('Belum ada catatan.'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, i) {
              final n = notes[i];
              return ListTile(
                title: Text(n.title),
                subtitle: n.body.isEmpty ? null : Text(n.body),
                trailing: Icon(
                  n.dirty ? Icons.cloud_off : Icons.cloud_done,
                  color: n.dirty ? Colors.orange : Colors.green,
                ),
                onLongPress: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Hapus catatan?'),
                      content: Text('Hapus "${n.title}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && n.id != null) {
                    await ref.read(notesProvider.notifier).remove(n.id!);
                    ref.invalidate(dirtyCountProvider);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await _promptText(context, 'Judul catatan');
          if (title == null || title.trim().isEmpty) return;
          await ref.read(notesProvider.notifier).add(title.trim(), '');
          ref.invalidate(dirtyCountProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _promptText(BuildContext context, String label) {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(label),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}