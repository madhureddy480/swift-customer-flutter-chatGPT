import 'package:dr_swift_diagnostics/features/checkout/data/checkout_repository.dart';
import 'package:dr_swift_diagnostics/features/checkout/data/mock_checkout_repository.dart';
import 'package:dr_swift_diagnostics/features/checkout/domain/checkout_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return MockCheckoutRepository();
});

final checkoutControllerProvider =
    StateNotifierProvider<CheckoutController, CheckoutFlowState>((ref) {
  return CheckoutController(ref.watch(checkoutRepositoryProvider));
});

class CheckoutFlowState {
  const CheckoutFlowState({
    this.isPlacingOrder = false,
    this.placedOrder,
    this.errorMessage,
  });

  final bool isPlacingOrder;
  final PlacedOrder? placedOrder;
  final String? errorMessage;
}

class CheckoutController extends StateNotifier<CheckoutFlowState> {
  CheckoutController(this._repository) : super(const CheckoutFlowState());

  final CheckoutRepository _repository;

  Future<PlacedOrder?> placeOrder({
    required CheckoutDetails details,
    required int totalRupees,
  }) async {
    state = const CheckoutFlowState(isPlacingOrder: true);
    try {
      final order = await _repository.placeOrder(
        details: details,
        totalRupees: totalRupees,
      );
      state = CheckoutFlowState(placedOrder: order);
      return order;
    } catch (error) {
      state = CheckoutFlowState(errorMessage: error.toString());
      return null;
    }
  }

  void reset() {
    state = const CheckoutFlowState();
  }
}
