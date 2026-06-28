import 'package:dr_swift_diagnostics/features/catalog/data/category_ui_metadata.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/catalog_view_models.dart';
import 'package:dr_swift_diagnostics/features/catalog/data/models/catalog_models.dart';
import 'package:dr_swift_diagnostics/features/profiles/data/health_profile_data.dart';
import 'package:flutter/material.dart';

abstract final class CatalogUiMapper {
  static HealthCategory toHealthCategory(
    SymptomCategory category,
    Map<String, CatalogTest> testsByCode,
  ) {
    final meta = CategoryUiMetadata.forSlug(category.slug);
    final tests = category.tests
        .map((ref) => testsByCode[ref.code])
        .whereType<CatalogTest>()
        .map(toHealthTest)
        .toList();

    return HealthCategory(
      id: category.slug,
      name: category.name,
      testCount: category.testCount,
      icon: meta.icon,
      color: meta.color,
      tests: tests,
    );
  }

  static HealthTest toHealthTest(CatalogTest test) {
    final symptoms = test.attributes.symptoms;
    final preparation = test.attributes.fastingRequired
        ? 'Fasting of 8-10 hours required before sample collection.'
        : 'No special preparation required.';

    return HealthTest(
      id: test.slug,
      name: _displayName(test.name),
      subtitle: test.shortDescription,
      price: test.priceRupees,
      sampleType: test.attributes.sampleType,
      tags: [
        test.attributes.sampleType,
        if (test.attributes.fastingRequired) 'Fasting Required',
        'NABL Labs',
      ],
      whatIsIt: test.longDescription.isNotEmpty
          ? test.longDescription.split('\n').first
          : test.name,
      whyTakeThisTest: symptoms.isNotEmpty
          ? 'Recommended when you experience ${symptoms.take(3).join(', ')}.'
          : 'Helps your doctor assess ${test.name} accurately.',
      referenceRanges: _referenceRangesFor(test),
      preparation: preparation,
      oftenBookedWith: test.attributes.includedTests.take(3).toList(),
    );
  }

  static HealthProfileData toHealthProfile(
    CatalogProfile profile,
    Map<String, CatalogTest> testsByCode,
  ) {
    final meta = ProfileUiMetadata.forSlug(profile.slug);
    final includedTests = profile.includedTests
        .map((ref) {
          final catalogTest =
              ref.code != null ? testsByCode[ref.code] : null;
          return ProfileTestItem(
            name: _displayName(ref.name),
            subtitle: ref.nameTelugu.isNotEmpty
                ? ref.nameTelugu
                : (catalogTest?.shortDescription ?? ref.name),
            price: catalogTest?.priceRupees ?? 0,
          );
        })
        .toList();

    final originalPrice = includedTests.fold<int>(
      0,
      (sum, item) => sum + item.price,
    );
    final hasDiscount = originalPrice > profile.priceRupees && originalPrice > 0;
    final discountPct = hasDiscount
        ? (((originalPrice - profile.priceRupees) / originalPrice) * 100).round()
        : 0;

    return HealthProfileData(
      slug: profile.slug,
      name: profile.name,
      shortName: profile.shortName,
      iconAsset: meta.iconAsset,
      testCount: profile.testCount,
      price: profile.priceRupees,
      originalPrice: hasDiscount ? originalPrice : profile.priceRupees,
      discount: hasDiscount ? '$discountPct% OFF' : '',
      color: meta.color,
      description: meta.description,
      whatIsItFor: meta.whatIsItFor,
      highlights: meta.highlights,
      whoShouldTakeThis: meta.whoShouldTakeThis,
      preparation: meta.preparation,
      tests: includedTests,
    );
  }

  static Map<String, CatalogTest> indexTestsByCode(List<CatalogTest> tests) {
    return {
      for (final test in tests)
        if (test.attributes.internalCode.isNotEmpty)
          test.attributes.internalCode: test,
    };
  }

  static String _displayName(String name) {
    return name
        .replaceAll('-Serum', '')
        .replaceAll('-WB-EDTA', '')
        .replaceAll('(GHb/HbA1c)', '')
        .trim();
  }

  static List<ReferenceRange> _referenceRangesFor(CatalogTest test) {
    final slug = test.slug;
    if (slug.contains('hba1c') || slug.contains('glycosylated-hemoglobin')) {
      return _hba1cRanges;
    }
    return _standardRanges;
  }

  static const _hba1cRanges = <ReferenceRange>[
    ReferenceRange(
      label: '< 5.7',
      value: 'Normal',
      color: Color(0xFF167B4B),
      backgroundColor: Color(0xFFE6F6EC),
    ),
    ReferenceRange(
      label: '5.7–6.4',
      value: 'Prediabetes',
      color: Color(0xFF4A7E23),
      backgroundColor: Color(0xFFEDF6DF),
    ),
    ReferenceRange(
      label: '6.5–7.9',
      value: 'High',
      color: Color(0xFFB66A00),
      backgroundColor: Color(0xFFFFF0D5),
    ),
    ReferenceRange(
      label: '≥ 8.0',
      value: 'Very High',
      color: Color(0xFFC93636),
      backgroundColor: Color(0xFFFFE6E6),
    ),
  ];

  static const _standardRanges = <ReferenceRange>[
    ReferenceRange(
      label: 'Low',
      value: 'Below range',
      color: Color(0xFF2474B5),
      backgroundColor: Color(0xFFE8F4FD),
    ),
    ReferenceRange(
      label: 'Normal',
      value: 'In range',
      color: Color(0xFF167B4B),
      backgroundColor: Color(0xFFE6F6EC),
    ),
    ReferenceRange(
      label: 'High',
      value: 'Review',
      color: Color(0xFFB66A00),
      backgroundColor: Color(0xFFFFF0D5),
    ),
  ];
}
