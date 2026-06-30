import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/authentication/domain/auth_models.dart';
import 'package:dr_swift_diagnostics/features/authentication/presentation/providers/auth_controller.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _ink = Color(0xFF1A1C1E);

class AuthOtpScreen extends ConsumerStatefulWidget {
  const AuthOtpScreen({required this.nextRoute, super.key});

  final String nextRoute;

  @override
  ConsumerState<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends ConsumerState<AuthOtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    final success =
        await ref.read(authControllerProvider.notifier).verifyOtp(_otp);
    if (!mounted || !success) return;
    context.go(
      '${RoutePaths.authAccountCreated}?next=${Uri.encodeComponent(widget.nextRoute)}',
    );
  }

  Future<void> _resend() async {
    final phone = ref.read(authControllerProvider).pendingPhone;
    if (phone == null) return;
    final digits = phone.replaceAll(RegExp(r'\D'), '').substring(2);
    await ref.read(authControllerProvider.notifier).sendOtp(digits);
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_otp.length == 6) {
      _verify();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isVerifying = auth.status == AuthStatus.verifyingOtp;
    final canResend = auth.resendSecondsRemaining == 0;

    return DsScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter OTP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sent to ${auth.pendingPhone ?? 'your number'}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF667085)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mock OTP: 123456',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryVibrant,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 44,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(counterText: ''),
                    onChanged: (value) => _onChanged(index, value),
                  ),
                );
              }),
            ),
            if (auth.errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                auth.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            DsPrimaryButton(
              label: 'Verify OTP',
              isLoading: isVerifying,
              onPressed: isVerifying || _otp.length < 6 ? null : _verify,
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: canResend ? _resend : null,
              child: Text(
                canResend
                    ? 'Resend OTP'
                    : 'Resend in ${auth.resendSecondsRemaining}s',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
