import 'package:dr_swift_diagnostics/features/cart/data/cart_repository.dart';
import 'package:dr_swift_diagnostics/features/cart/data/mock_cart_repository.dart';
import 'package:dr_swift_diagnostics/features/cart/domain/cart_models.dart';
import 'package:dr_swift_diagnostics/features/cart/presentation/providers/cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return MockCartRepository();
});

final cartControllerProvider =
    StateNotifierProvider<CartController, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartController(repository)..load();
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartControllerProvider).itemCount;
});

final cartIsInCartProvider = Provider.family<bool, String>((ref, itemId) {
  return ref.watch(cartControllerProvider).contains(itemId);
});
