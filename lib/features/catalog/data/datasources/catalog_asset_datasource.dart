import 'dart:convert';

import 'package:dr_swift_diagnostics/features/catalog/data/catalog_asset_paths.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/models/catalog_models.dart';
import 'package:flutter/services.dart';

class CatalogAssetDataSource {
  Future<CatalogBundle> loadCatalog() async {
    final raw = await rootBundle.loadString(CatalogAssetPaths.catalog);
    return CatalogBundle.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  Future<List<SymptomCategory>> loadCategories() async {
    final raw = await rootBundle.loadString(CatalogAssetPaths.categories);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['categories'] as List<dynamic>? ?? const [])
        .map((e) => SymptomCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CatalogProfile>> loadProfiles() async {
    final raw = await rootBundle.loadString(CatalogAssetPaths.profiles);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['profiles'] as List<dynamic>? ?? const [])
        .map((e) => CatalogProfile.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
