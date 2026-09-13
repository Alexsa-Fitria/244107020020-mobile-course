import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductItem {
  ProductItem(this.name, {this.isAvailable = true});
  final String name;
  final bool isAvailable;

  ProductItem copyWith({String? name, bool? isAvailable}) =>
      ProductItem(name ?? this.name, isAvailable: isAvailable ?? this.isAvailable);
}

class ProductsNotifier extends AsyncNotifier> {
  @override
  Future> build() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi network
    return ['Keyboard', 'Mouse', 'Monitor'];
  }

  Future refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }

  Future> _fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    return ['Keyboard', 'Mouse', 'Monitor', 'Headset'];
  }
}

final productsProvider =
    AsyncNotifierProvider>(
        ProductsNotifier.new);