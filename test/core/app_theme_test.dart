import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:dr_swift_diagnostics/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppTheme uses brand primary color', (tester) async {
    final theme = AppTheme.light();
    expect(theme.colorScheme.primary, AppColors.primary);
  });
}
