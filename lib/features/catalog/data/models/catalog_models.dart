/// DTOs mirroring DrSwift-CMS `GET /api/v1/public/catalog` responses.
class CatalogBundle {
  const CatalogBundle({
    required this.tests,
    required this.promotions,
    required this.featuredCollections,
  });

  final List<CatalogTest> tests;
  final List<CatalogPromotion> promotions;
  final List<Map<String, dynamic>> featuredCollections;

  factory CatalogBundle.fromJson(Map<String, dynamic> json) {
    return CatalogBundle(
      tests: (json['tests'] as List<dynamic>? ?? const [])
          .map((e) => CatalogTest.fromJson(e as Map<String, dynamic>))
          .toList(),
      promotions: (json['promotions'] as List<dynamic>? ?? const [])
          .map((e) => CatalogPromotion.fromJson(e as Map<String, dynamic>))
          .toList(),
      featuredCollections: (json['featuredCollections'] as List<dynamic>? ??
              const [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }
}

class CatalogTest {
  const CatalogTest({
    required this.id,
    required this.slug,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.testType,
    required this.priceCents,
    required this.currency,
    required this.parameterCount,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.attributes,
    required this.isFeatured,
    required this.sortOrder,
    required this.active,
    this.badge,
  });

  final String id;
  final String slug;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String testType;
  final int priceCents;
  final String currency;
  final int parameterCount;
  final String imageUrl;
  final String thumbnailUrl;
  final CatalogAttributes attributes;
  final String? badge;
  final bool isFeatured;
  final int sortOrder;
  final bool active;

  int get priceRupees => priceCents ~/ 100;

  bool get isProfile => testType == 'Profile';

  factory CatalogTest.fromJson(Map<String, dynamic> json) {
    return CatalogTest(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      longDescription: json['longDescription'] as String? ?? '',
      testType: json['testType'] as String? ?? 'Test',
      priceCents: (json['priceCents'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'INR',
      parameterCount: (json['parameterCount'] as num?)?.toInt() ?? 1,
      imageUrl: json['imageUrl'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      attributes: CatalogAttributes.fromJson(
        Map<String, dynamic>.from(
          json['attributesJson'] as Map? ?? const {},
        ),
      ),
      badge: json['badge'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }
}

class CatalogAttributes {
  const CatalogAttributes({
    required this.sampleType,
    required this.fastingRequired,
    required this.noAlcohol,
    required this.demographics,
    required this.testCategories,
    required this.testAudience,
    required this.testType,
    required this.symptoms,
    required this.internalCode,
    required this.externalCode,
    required this.alternativeNames,
    required this.includedTests,
    this.numberOfTests,
  });

  final String sampleType;
  final bool fastingRequired;
  final bool noAlcohol;
  final List<String> demographics;
  final List<String> testCategories;
  final List<String> testAudience;
  final String testType;
  final List<String> symptoms;
  final String internalCode;
  final String externalCode;
  final String alternativeNames;
  final List<String> includedTests;
  final int? numberOfTests;

  factory CatalogAttributes.fromJson(Map<String, dynamic> json) {
    return CatalogAttributes(
      sampleType: json['sampleType'] as String? ?? 'Blood',
      fastingRequired: json['fastingRequired'] as bool? ?? false,
      noAlcohol: json['noAlcohol'] as bool? ?? false,
      demographics: _stringList(json['demographics']),
      testCategories: _stringList(json['testCategories']),
      testAudience: _stringList(json['testAudience']),
      testType: json['testType'] as String? ?? 'Test',
      symptoms: _stringList(json['symptoms']),
      internalCode: json['internalCode'] as String? ?? '',
      externalCode: json['externalCode'] as String? ?? '',
      alternativeNames: json['alternativeNames'] as String? ?? '',
      includedTests: _stringList(json['includedTests']),
      numberOfTests: (json['numberOfTests'] as num?)?.toInt(),
    );
  }
}

class CatalogPromotion {
  const CatalogPromotion({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.linkSlug,
    required this.originalPriceCents,
    required this.salePriceCents,
    required this.currency,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String linkSlug;
  final int originalPriceCents;
  final int? salePriceCents;
  final String currency;

  factory CatalogPromotion.fromJson(Map<String, dynamic> json) {
    return CatalogPromotion(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      linkSlug: json['linkSlug'] as String? ?? '',
      originalPriceCents: (json['originalPriceCents'] as num?)?.toInt() ?? 0,
      salePriceCents: (json['salePriceCents'] as num?)?.toInt(),
      currency: json['currency'] as String? ?? 'INR',
    );
  }
}

class SymptomCategory {
  const SymptomCategory({
    required this.slug,
    required this.name,
    required this.testCount,
    required this.testCodes,
    required this.tests,
  });

  final String slug;
  final String name;
  final int testCount;
  final List<String> testCodes;
  final List<CategoryTestRef> tests;

  factory SymptomCategory.fromJson(Map<String, dynamic> json) {
    return SymptomCategory(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      testCount: (json['testCount'] as num?)?.toInt() ?? 0,
      testCodes: _stringList(json['testCodes']),
      tests: (json['tests'] as List<dynamic>? ?? const [])
          .map((e) => CategoryTestRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CategoryTestRef {
  const CategoryTestRef({
    required this.code,
    required this.slug,
    required this.name,
    required this.nameTelugu,
    required this.symptoms,
  });

  final String code;
  final String slug;
  final String name;
  final String nameTelugu;
  final List<String> symptoms;

  factory CategoryTestRef.fromJson(Map<String, dynamic> json) {
    return CategoryTestRef(
      code: json['code'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameTelugu: json['nameTelugu'] as String? ?? '',
      symptoms: _stringList(json['symptoms']),
    );
  }
}

class CatalogProfile {
  const CatalogProfile({
    required this.code,
    required this.slug,
    required this.name,
    required this.shortName,
    required this.testCount,
    required this.priceCents,
    required this.currency,
    required this.includedTestCodes,
    required this.includedTests,
  });

  final String code;
  final String slug;
  final String name;
  final String shortName;
  final int testCount;
  final int priceCents;
  final String currency;
  final List<String> includedTestCodes;
  final List<ProfileTestRef> includedTests;

  int get priceRupees => priceCents ~/ 100;

  factory CatalogProfile.fromJson(Map<String, dynamic> json) {
    return CatalogProfile(
      code: json['code'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortName: json['shortName'] as String? ?? '',
      testCount: (json['testCount'] as num?)?.toInt() ?? 0,
      priceCents: (json['priceCents'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'INR',
      includedTestCodes: _stringList(json['includedTestCodes']),
      includedTests: (json['includedTests'] as List<dynamic>? ?? const [])
          .map((e) => ProfileTestRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProfileTestRef {
  const ProfileTestRef({
    required this.code,
    required this.slug,
    required this.name,
    required this.nameTelugu,
  });

  final String? code;
  final String slug;
  final String name;
  final String nameTelugu;

  factory ProfileTestRef.fromJson(Map<String, dynamic> json) {
    return ProfileTestRef(
      code: json['code'] as String?,
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameTelugu: json['nameTelugu'] as String? ?? '',
    );
  }
}

List<String> _stringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((e) => e.toString()).toList();
}
