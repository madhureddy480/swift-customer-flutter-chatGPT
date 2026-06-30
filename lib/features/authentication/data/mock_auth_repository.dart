import 'package:dr_swift_diagnostics/features/authentication/data/auth_repository.dart';
import 'package:dr_swift_diagnostics/features/authentication/domain/auth_models.dart';

class MockAuthRepository implements AuthRepository {
  static const validOtp = '123456';
  static const _latency = Duration(milliseconds: 900);

  AuthUser? _currentUser;

  @override
  Future<void> sendOtp({required String phoneE164}) async {
    await Future<void>.delayed(_latency);
    if (phoneE164.length < 10) {
      throw const AuthException('Enter a valid mobile number');
    }
  }

  @override
  Future<AuthUser> verifyOtp({
    required String phoneE164,
    required String otp,
  }) async {
    await Future<void>.delayed(_latency);
    if (otp != validOtp) {
      throw const AuthException('Invalid OTP. Try 123456 for mock login.');
    }

    _currentUser = AuthUser(
      id: 'mock-user-1',
      phoneE164: phoneE164,
      displayName: 'Dr Swift User',
    );
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
