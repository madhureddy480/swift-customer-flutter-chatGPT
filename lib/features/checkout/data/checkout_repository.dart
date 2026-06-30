import 'package:dr_swift_diagnostics/features/checkout/domain/checkout_models.dart';

abstract interface class CheckoutRepository {
  Future<PlacedOrder> placeOrder({
    required CheckoutDetails details,
    required int totalRupees,
  });
}
