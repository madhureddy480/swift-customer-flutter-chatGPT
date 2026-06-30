import 'package:dr_swift_diagnostics/features/authentication/data/mock_auth_repository.dart';
import 'package:dr_swift_diagnostics/features/authentication/domain/auth_models.dart';
import 'package:dr_swift_diagnostics/features/authentication/presentation/providers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthController', () {
    late AuthController controller;
    var authenticated = false;

    setUp(() {
      authenticated = false;
      controller = AuthController(
        repository: MockAuthRepository(),
        onAuthenticated: (_) => authenticated = true,
        onSignedOut: () => authenticated = false,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('sendOtp rejects invalid phone', () async {
      final sent = await controller.sendOtp('123');

      expect(sent, isFalse);
      expect(controller.state.status, AuthStatus.error);
    });

    test('sendOtp succeeds for valid Indian number', () async {
      final sent = await controller.sendOtp('9876543210');

      expect(sent, isTrue);
      expect(controller.state.status, AuthStatus.otpSent);
      expect(controller.state.pendingPhone, '+919876543210');
    });

    test('verifyOtp accepts mock code and authenticates', () async {
      await controller.sendOtp('9876543210');
      final verified = await controller.verifyOtp(MockAuthRepository.validOtp);

      expect(verified, isTrue);
      expect(controller.state.status, AuthStatus.authenticated);
      expect(authenticated, isTrue);
    });

    test('verifyOtp rejects wrong code', () async {
      await controller.sendOtp('9876543210');
      final verified = await controller.verifyOtp('000000');

      expect(verified, isFalse);
      expect(authenticated, isFalse);
      expect(controller.state.errorMessage, isNotNull);
    });
  });
}
