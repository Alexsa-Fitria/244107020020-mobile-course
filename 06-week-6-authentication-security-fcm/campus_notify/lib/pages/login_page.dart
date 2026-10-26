import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailCtrl = TextEditingController(text: 'admin@kampus.ac.id');
  final _passCtrl = TextEditingController(text: 'password123');

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    ref.listen(authStateProvider, (previous, next) {
      if (next.value == true) {
        context.go('/'); // Kalau sukses login, pindah ke Home
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login Campus Notify')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            authState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      ref.read(authStateProvider.notifier).login(
                            _emailCtrl.text,
                            _passCtrl.text,
                          );
                    },
                    child: const Text('Login'),
                  ),
            if (authState.hasError)
              Text(
                'Error: ${authState.error}',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}