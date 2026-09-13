import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_provider.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productCatalogAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
      ),
      body: productCatalogAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (errorReason, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Gagal memuat: $errorReason'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(productsProvider);
                  },
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        },
        data: (productList) {
          return ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: Text(productList[index]),
              );
            },
          );
        },
      ),
    );
  }
}