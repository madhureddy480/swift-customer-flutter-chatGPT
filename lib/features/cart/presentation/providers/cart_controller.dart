import 'package:dr_swift_diagnostics/features/cart/data/cart_repository.dart';
import 'package:dr_swift_diagnostics/features/cart/domain/cart_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/profiles/data/health_profile_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartController extends StateNotifier<CartState> {
  CartController(this._repository) : super(const CartState());

  final CartRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final loaded = await _repository.loadCart();
      state = loaded.copyWith(isLoading: false);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> addTest(HealthTest test) async {
    final id = CartLineItem.testId(test.id);
    final existing = _indexOf(id);
    if (existing != null) {
      await updateQuantity(id, state.items[existing].quantity + 1);
      return;
    }

    await _persist(
      state.copyWith(
        items: [
          ...state.items,
          CartLineItem(
            id: id,
            type: CartItemType.test,
            slug: test.id,
            name: test.name,
            subtitle: test.subtitle,
            unitPriceRupees: test.price,
            originalPriceRupees: test.price,
          ),
        ],
      ),
    );
  }

  Future<void> addProfile(HealthProfileData profile) async {
    final id = CartLineItem.profileId(profile.slug);
    if (state.contains(id)) return;

    await _persist(
      state.copyWith(
        items: [
          ...state.items,
          CartLineItem(
            id: id,
            type: CartItemType.profile,
            slug: profile.slug,
            name: profile.name,
            subtitle: '${profile.testCount} tests included',
            unitPriceRupees: profile.price,
            originalPriceRupees: profile.originalPrice,
          ),
        ],
      ),
    );
  }

  Future<void> removeItem(String id) async {
    await _persist(
      state.copyWith(
        items: state.items.where((item) => item.id != id).toList(),
      ),
    );
  }

  Future<void> updateQuantity(String id, int quantity) async {
    if (quantity < 1) {
      await removeItem(id);
      return;
    }

    final index = _indexOf(id);
    if (index == null) return;

    final item = state.items[index];
    if (!item.allowsQuantity && quantity != 1) return;

    final updated = [...state.items];
    updated[index] = item.copyWith(quantity: quantity);
    await _persist(state.copyWith(items: updated));
  }

  Future<void> clear() async {
    await _persist(const CartState());
  }

  bool isInCart(String id) => state.contains(id);

  int? _indexOf(String id) {
    final index = state.items.indexWhere((item) => item.id == id);
    return index == -1 ? null : index;
  }

  Future<void> _persist(CartState next) async {
    state = next.copyWith(isLoading: true, errorMessage: null);
    try {
      final saved = await _repository.saveCart(next);
      state = saved.copyWith(isLoading: false);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }
}
