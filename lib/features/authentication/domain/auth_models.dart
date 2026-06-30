import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String phoneE164,
    required String displayName,
    String? email,
  }) = _AuthUser;
}

enum AuthStatus {
  unauthenticated,
  sendingOtp,
  otpSent,
  verifyingOtp,
  authenticated,
  error,
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.unauthenticated) AuthStatus status,
    AuthUser? user,
    String? pendingPhone,
    String? errorMessage,
    @Default(0) int resendSecondsRemaining,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
}
