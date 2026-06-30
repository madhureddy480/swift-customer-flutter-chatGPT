import 'package:dr_swift_diagnostics/features/checkout/data/checkout_repository.dart';
import 'package:dr_swift_diagnostics/features/checkout/domain/checkout_models.dart';

class MockCheckoutRepository implements CheckoutRepository {
  static const _latency = Duration(seconds: 2);

  @override
  Future<PlacedOrder> placeOrder({
    required CheckoutDetails details,
    required int totalRupees,
  }) async {
    await Future<void>.delayed(_latency);
    final now = DateTime.now();
    return PlacedOrder(
      orderId: 'DS${now.millisecondsSinceEpoch}'.substring(0, 12),
      bookedAt: now,
      collectionAddress: details.collectionAddress,
      collectionTimeSlot: details.collectionTimeSlot,
      totalRupees: totalRupees,
    );
  }
}
