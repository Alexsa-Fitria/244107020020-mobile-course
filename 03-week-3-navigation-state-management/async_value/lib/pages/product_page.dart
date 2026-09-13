import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_provider.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productMetrics = ref.watch(productStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Statistics'),
      ),
      body: productMetrics.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (err, st) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    ref
                        .read(productStatsProvider.notifier)
                        .refresh();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        },
        data: (dataList) {
          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (ctx, idx) {
              return ListTile(
                leading: const Icon(Icons.inventory_2),
                title: Text(dataList[idx]),
              );
            },
          );
        },
      ),
    );
  }
}