import 'dart:async';

import 'package:dr_swift_diagnostics/features/authentication/data/auth_repository.dart';
import 'package:dr_swift_diagnostics/features/authentication/data/mock_auth_repository.dart';
import 'package:dr_swift_diagnostics/features/authentication/domain/auth_models.dart';
import 'package:dr_swift_diagnostics/features/session/presentation/session_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    repository: ref.watch(authRepositoryProvider),
    onAuthenticated: (user) {
      ref.read(userSessionControllerProvider.notifier).setAuthenticated(
            phoneE164: user.phoneE164,
            displayName: user.displayName,
          );
    },
    onSignedOut: () {
      ref.read(userSessionControllerProvider.notifier).setGuest();
    },
  );
});

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository repository,
    required void Function(AuthUser user) onAuthenticated,
    required VoidCallback onSignedOut,
  })  : _repository = repository,
        _onAuthenticated = onAuthenticated,
        _onSignedOut = onSignedOut,
        super(const AuthState());

  final AuthRepository _repository;
  final void Function(AuthUser user) _onAuthenticated;
  final VoidCallback _onSignedOut;
  Timer? _resendTimer;

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<bool> sendOtp(String phoneDigits) async {
    final normalized = _normalizePhone(phoneDigits);
    if (normalized == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Enter a valid 10-digit mobile number',
      );
      return false;
    }

    state = state.copyWith(
      status: AuthStatus.sendingOtp,
      errorMessage: null,
      pendingPhone: normalized,
    );

    try {
      await _repository.sendOtp(phoneE164: normalized);
      _startResendTimer();
      state = state.copyWith(status: AuthStatus.otpSent);
      return true;
    } on AuthException catch (error) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: error.message,
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    final phone = state.pendingPhone;
    if (phone == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Start with your mobile number first',
      );
      return false;
    }

    state = state.copyWith(
      status: AuthStatus.verifyingOtp,
      errorMessage: null,
    );

    try {
      final user = await _repository.verifyOtp(phoneE164: phone, otp: otp);
      _resendTimer?.cancel();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
      _onAuthenticated(user);
      return true;
    } on AuthException catch (error) {
      state = state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: error.message,
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _resendTimer?.cancel();
    state = const AuthState();
    _onSignedOut();
  }

  void clearError() {
    if (state.errorMessage == null) return;
    state = state.copyWith(errorMessage: null);
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    state = state.copyWith(resendSecondsRemaining: 30);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.resendSecondsRemaining - 1;
      if (next <= 0) {
        timer.cancel();
        state = state.copyWith(resendSecondsRemaining: 0);
      } else {
        state = state.copyWith(resendSecondsRemaining: next);
      }
    });
  }

  String? _normalizePhone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return '+91$digits';
    if (digits.length == 12 && digits.startsWith('91')) return '+$digits';
    return null;
  }
}
