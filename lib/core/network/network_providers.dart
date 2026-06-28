import 'package:dio/dio.dart';
import 'package:dr_swift_diagnostics/core/config/config_providers.dart';
import 'package:dr_swift_diagnostics/core/network/api_client.dart';
import 'package:dr_swift_diagnostics/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final client = ref.watch(apiClientProvider);
  return client.dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient(config: config, tokenStorage: tokenStorage);
});
