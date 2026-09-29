import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/settings_page.dart'; // dari Praktikum 1
import 'pages/notes_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(darkModeProvider).value ?? false;
    return MaterialApp(
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: const NotesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}