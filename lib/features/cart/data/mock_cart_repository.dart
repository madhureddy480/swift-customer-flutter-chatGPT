import 'package:dr_swift_diagnostics/features/cart/data/cart_repository.dart';
import 'package:dr_swift_diagnostics/features/cart/domain/cart_models.dart';

/// In-memory cart with realistic latency for session persistence.
class MockCartRepository implements CartRepository {
  CartState _state = const CartState();
  static const _latency = Duration(milliseconds: 180);

  @override
  Future<CartState> loadCart() async {
    await Future<void>.delayed(_latency);
    return _state;
  }

  @override
  Future<CartState> saveCart(CartState state) async {
    await Future<void>.delayed(_latency);
    _state = state;
    return _state;
  }
}
