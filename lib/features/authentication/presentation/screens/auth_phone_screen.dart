import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_brand_widgets.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/authentication/domain/auth_models.dart';
import 'package:dr_swift_diagnostics/features/authentication/presentation/providers/auth_controller.dart';
import 'package:dr_swift_diagnostics/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _ink = Color(0xFF1A1C1E);

class AuthPhoneScreen extends ConsumerStatefulWidget {
  const AuthPhoneScreen({required this.nextRoute, super.key});

  final String nextRoute;

  @override
  ConsumerState<AuthPhoneScreen> createState() => _AuthPhoneScreenState();
}

class _AuthPhoneScreenState extends ConsumerState<AuthPhoneScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final auth = ref.read(authControllerProvider.notifier);
    final sent = await auth.sendOtp(_phoneController.text);
    if (!mounted || !sent) return;
    await context.push(
      '${RoutePaths.authOtp}?next=${Uri.encodeComponent(widget.nextRoute)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isLoading = auth.status == AuthStatus.sendingOtp;

    return DsScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: DsLoginBrandLockup()),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Authentication Required',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to continue checkout. Guest booking is not available.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085), height: 1.4),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Enter mobile number',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 14, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🇮🇳', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 6),
                      Text(
                        '+91',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (auth.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                auth.errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            DsPrimaryButton(
              label: 'Continue',
              isLoading: isLoading,
              onPressed: isLoading ? null : _continue,
            ),
          ],
        ),
      ),
    );
  }
}
