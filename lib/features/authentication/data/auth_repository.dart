import 'package:dr_swift_diagnostics/features/authentication/domain/auth_models.dart';

abstract interface class AuthRepository {
  Future<void> sendOtp({required String phoneE164});

  Future<AuthUser> verifyOtp({
    required String phoneE164,
    required String otp,
  });

  Future<void> signOut();
}
