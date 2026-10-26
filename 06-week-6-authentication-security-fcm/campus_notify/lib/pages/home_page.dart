import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Tambahkan import ini
import '../providers/auth_provider.dart';
import '../messaging/push_service.dart'; // Tambahkan import ini

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _tokenSnippet = 'Memuat token...';

  @override
  void initState() {
    super.initState();
    _setupFcm();
  }

  Future<void> _setupFcm() async {
    // 1. Minta Izin Notifikasi
    await requestNotificationPermission();
    
    // 2. Ambil Token dan Tampilkan (dipotong 12 karakter)
    await initFcmToken(
      onToken: (token) async {
        if (mounted) {
          setState(() {
            _tokenSnippet = '${token.substring(0, 12)}...';
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              context.go('/login');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Selamat datang di Campus Notify!'),
            const SizedBox(height: 20),
            
            // --- BUKTI PRAKTIKUM 2: TAMPILAN TOKEN ---
            const Text('FCM Token (12 karakter pertama):', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_tokenSnippet, style: const TextStyle(color: Colors.blue, fontSize: 18)),
            const SizedBox(height: 20),
            // -----------------------------------------

            ElevatedButton(
              onPressed: () => context.go('/pengumuman/123'),
              child: const Text('Lihat Pengumuman'),
            ),
          ],
        ),
      ),
    );
  }
}