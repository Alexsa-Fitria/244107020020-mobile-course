import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnnouncementPage extends StatelessWidget {
  final String id;
  const AnnouncementPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Pengumuman #$id')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ini adalah halaman pengumuman dengan ID: $id'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Kembali ke Home'),
            ),
          ],
        ),
      ),
    );
  }
}