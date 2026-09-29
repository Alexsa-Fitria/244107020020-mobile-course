import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';

// 1. Provider repository
final noteRepositoryProvider =
    Provider<NoteRepository>((ref) => NoteRepository());

// 2. Provider daftar catatan (AsyncNotifier)
final notesProvider =
    AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() {
    return ref.watch(noteRepositoryProvider).fetchNotes();
  }

  Future<void> add(String title, String body) async {
    await ref.read(noteRepositoryProvider).addNote(title: title, body: body);
    ref.invalidateSelf(); // refresh daftar
    await future;        // tunggu reload selesai
  }

  Future<void> remove(int id) async {
    await ref.read(noteRepositoryProvider).deleteNote(id);
    ref.invalidateSelf();
    await future;
  }
}

// 3. UI halaman
class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final repo = ref.read(noteRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Offline'),
        actions: [
          // Badge dirty
          FutureBuilder<int>(
            future: repo.countDirty(),
            builder: (_, snap) {
              final count = snap.data ?? 0;
              if (count == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Chip(
                  label: Text('Dirty: $count'),
                  backgroundColor: Colors.orange.shade200,
                ),
              );
            },
          ),
        ],
      ),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
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
                subtitle: Text(n.body),
                trailing: n.dirty
                    ? const Icon(Icons.cloud_off, color: Colors.orange)
                    : const Icon(Icons.cloud_done, color: Colors.green),
                onLongPress: () => ref
                    .read(notesProvider.notifier)
                    .remove(n.id!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await _promptText(context, 'Judul catatan');
          if (title == null || title.isEmpty) return;
          await ref.read(notesProvider.notifier).add(title, '');
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