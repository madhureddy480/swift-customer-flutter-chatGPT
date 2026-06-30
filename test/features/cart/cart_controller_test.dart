import 'package:dr_swift_diagnostics/features/cart/data/mock_cart_repository.dart';
import 'package:dr_swift_diagnostics/features/cart/domain/cart_models.dart';
import 'package:dr_swift_diagnostics/features/cart/presentation/providers/cart_controller.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/profiles/data/health_profile_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _sampleTest = HealthTest(
  id: 'glucose-blood-fasting',
  name: 'Glucose-Blood-Fasting',
  subtitle: 'Fasting glucose',
  price: 99,
  sampleType: 'Blood',
  tags: ['Blood'],
  whatIsIt: 'Test',
  whyTakeThisTest: 'Screening',
  referenceRanges: [],
  preparation: 'Fast',
  oftenBookedWith: [],
);

const _sampleProfile = HealthProfileData(
  slug: 'drs-diabetic',
  name: 'Dr Swift Diabetic Profile',
  shortName: 'Diabetic',
  iconAsset: 'assets/icons/category-diabetes.svg',
  testCount: 12,
  price: 999,
  originalPrice: 1499,
  discount: '33% off',
  color: Color(0xFF18AA63),
  description: 'Profile',
  whatIsItFor: 'Diabetes screening',
  highlights: ['12 tests'],
  whoShouldTakeThis: 'Adults',
  preparation: ['Fasting required'],
  tests: [],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartController', () {
    late CartController controller;

    setUp(() {
      controller = CartController(MockCartRepository());
    });

    test('addTest adds item and increments quantity on duplicate', () async {
      await controller.addTest(_sampleTest);
      await controller.addTest(_sampleTest);

      expect(controller.state.items, hasLength(1));
      expect(controller.state.items.first.quantity, 2);
      expect(controller.state.itemCount, 2);
    });

    test('addProfile prevents duplicate profile lines', () async {
      await controller.addProfile(_sampleProfile);
      await controller.addProfile(_sampleProfile);

      expect(controller.state.items, hasLength(1));
      expect(controller.state.items.first.type, CartItemType.profile);
    });

    test('removeItem clears line', () async {
      await controller.addTest(_sampleTest);
      final id = CartLineItem.testId(_sampleTest.id);
      await controller.removeItem(id);

      expect(controller.state.isEmpty, isTrue);
    });

    test('discount totals reflect profile original price', () async {
      await controller.addProfile(_sampleProfile);

      expect(controller.state.discountRupees, 500);
      expect(controller.state.totalRupees, 999);
    });
  });
}
