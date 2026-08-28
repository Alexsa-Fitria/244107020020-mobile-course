import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Profil Mahasiswa')),
        body: const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.school, size: 72),
            SizedBox(height: 16),
            Text('Alexsa Fitria Ayu Siswoyo', style: TextStyle(fontSize: 24)),
            Text('244107020020', style: TextStyle(fontSize: 18)),
            Text('TI-3H', style: TextStyle(fontSize: 16)),
            Text('lexafitriayu@gmail.com', style: TextStyle(fontSize: 12, color: Colors.grey,fontStyle: FontStyle.italic)),
            Text('Pemrograman Mobile — Minggu 1'),
          ]),
        ),
      ),
    );
  }
}