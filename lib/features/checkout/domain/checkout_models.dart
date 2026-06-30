import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_models.freezed.dart';

@freezed
class CheckoutDetails with _$CheckoutDetails {
  const factory CheckoutDetails({
    required String patientName,
    required String mobileNumber,
    String? email,
    required String collectionAddress,
    required DateTime collectionDate,
    required String collectionTimeSlot,
  }) = _CheckoutDetails;
}

@freezed
class PlacedOrder with _$PlacedOrder {
  const factory PlacedOrder({
    required String orderId,
    required DateTime bookedAt,
    required String collectionAddress,
    required String collectionTimeSlot,
    required int totalRupees,
  }) = _PlacedOrder;
}
