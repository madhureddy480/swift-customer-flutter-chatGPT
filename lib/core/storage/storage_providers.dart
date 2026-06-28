import 'package:dr_swift_diagnostics/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageService(),
);

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage(ref.watch(secureStorageProvider));
});

final sessionProvider = FutureProvider<bool>((ref) async {
  final storage = ref.watch(tokenStorageProvider);
  return storage.hasValidSession();
});
