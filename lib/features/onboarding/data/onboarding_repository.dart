import 'package:dr_swift_diagnostics/core/constants/storage_keys.dart';
import 'package:dr_swift_diagnostics/core/storage/storage_providers.dart';
import 'package:dr_swift_diagnostics/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingRepository {
  const OnboardingRepository(this._secureStorage);

  final SecureStorageService _secureStorage;

  Future<bool> isComplete() async {
    try {
      final value = await _secureStorage
          .read(StorageKeys.onboardingComplete)
          .timeout(const Duration(seconds: 2));
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<void> markComplete() async {
    await _secureStorage.write(StorageKeys.onboardingComplete, 'true');
  }
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(ref.watch(secureStorageProvider));
});

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  return ref.watch(onboardingRepositoryProvider).isComplete();
});
