import 'package:dr_swift_diagnostics/features/cart/domain/cart_models.dart';

/// Cart persistence contract — swap [MockCartRepository] for API later.
abstract interface class CartRepository {
  Future<CartState> loadCart();

  Future<CartState> saveCart(CartState state);
}
