import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_spacing.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_buttons.dart';
import 'package:dr_swift_diagnostics/core/widgets/ds_scaffold.dart';
import 'package:dr_swift_diagnostics/features/authentication/presentation/providers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _ink = Color(0xFF1A1C1E);

class AuthAccountCreatedScreen extends ConsumerWidget {
  const AuthAccountCreatedScreen({required this.nextRoute, super.key});

  final String nextRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    return DsScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Color(0xFF13A86B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Account Created',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user != null
                    ? 'Welcome, ${user.displayName}'
                    : 'You are signed in and ready to book.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  height: 1.4,
                ),
              ),
              if (user?.phoneE164 != null) ...[
                const SizedBox(height: 6),
                Text(
                  user!.phoneE164,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primaryVibrant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const Spacer(),
              DsPrimaryButton(
                label: 'Continue Checkout',
                onPressed: () => context.go(nextRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
