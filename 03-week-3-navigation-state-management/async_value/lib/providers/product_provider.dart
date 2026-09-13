import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mengatur status async untuk data produk.
class ProductNotifier extends AsyncNotifier> {
  @override
  Future> build() async {
    // Simulasi jeda jaringan selama 2 detik.
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi kegagalan acak 30% berdasarkan kondisi tertentu.
    if (math.Random().nextDouble() < 0.3) {
      throw Exception('Gagal memuat data produk');
    }

    return [
      'Laptop ROG Strix',
      'Mechanical Keyboard',
      'Wireless Mouse Gaming',
    ];
  }

  // Memuat ulang state provider.
  void refresh() {
    ref.invalidateSelf();
  }
}

// Provider global untuk konsumsi di UI.
final productsProvider =
    AsyncNotifierProvider>(
  ProductNotifier.new,
);