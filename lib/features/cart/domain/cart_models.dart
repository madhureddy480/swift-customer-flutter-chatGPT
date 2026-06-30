import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_models.freezed.dart';

enum CartItemType { test, profile }

@freezed
class CartLineItem with _$CartLineItem {
  const CartLineItem._();

  const factory CartLineItem({
    required String id,
    required CartItemType type,
    required String slug,
    required String name,
    required String subtitle,
    required int unitPriceRupees,
    required int originalPriceRupees,
    @Default(1) int quantity,
  }) = _CartLineItem;

  int get lineTotal => unitPriceRupees * quantity;

  int get lineDiscount =>
      originalPriceRupees > unitPriceRupees
          ? (originalPriceRupees - unitPriceRupees) * quantity
          : 0;

  bool get allowsQuantity => type == CartItemType.test;

  String get formattedUnitPrice => '₹$unitPriceRupees';

  String get formattedLineTotal => '₹$lineTotal';

  static String testId(String slug) => 'test:$slug';

  static String profileId(String slug) => 'profile:$slug';
}

@freezed
class CartState with _$CartState {
  const CartState._();

  const factory CartState({
    @Default(<CartLineItem>[]) List<CartLineItem> items,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _CartState;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  int get subtotalRupees =>
      items.fold(0, (sum, item) => sum + item.lineTotal);

  int get discountRupees =>
      items.fold(0, (sum, item) => sum + item.lineDiscount);

  int get totalRupees => subtotalRupees;

  bool get isEmpty => items.isEmpty;

  bool contains(String id) => items.any((item) => item.id == id);
}
