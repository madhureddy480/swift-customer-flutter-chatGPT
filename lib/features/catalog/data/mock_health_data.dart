import 'package:flutter/material.dart';

class ReferenceRange {
  const ReferenceRange({
    required this.label,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color backgroundColor;
}

class HealthTest {
  const HealthTest({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.sampleType,
    required this.tags,
    required this.whatIsIt,
    required this.whyTakeThisTest,
    required this.referenceRanges,
    required this.preparation,
    required this.oftenBookedWith,
  });

  final String id;
  final String name;
  final String subtitle;
  final int price;
  final String sampleType;
  final List<String> tags;
  final String whatIsIt;
  final String whyTakeThisTest;
  final List<ReferenceRange> referenceRanges;
  final String preparation;
  final List<String> oftenBookedWith;

  String get formattedPrice => '₹$price';
}

class HealthCategory {
  const HealthCategory({
    required this.id,
    required this.name,
    required this.testCount,
    required this.icon,
    required this.color,
    required this.tests,
  });

  final String id;
  final String name;
  final int testCount;
  final IconData icon;
  final Color color;
  final List<HealthTest> tests;
}

abstract final class MockHealthData {
  static final categories = <HealthCategory>[
    HealthCategory(
      id: 'diabetes-metabolic',
      name: 'Diabetes & Metabolic Health',
      testCount: 26,
      icon: Icons.water_drop_outlined,
      color: const Color(0xFF24B7E5),
      tests: [
        _test(
          id: 'hba1c',
          name: 'HbA1c',
          subtitle: 'Glycated Hemoglobin',
          price: 299,
          whatIsIt:
              'HbA1c shows your average blood sugar levels over the past 2–3 months.',
          whyTake:
              'To diagnose diabetes and monitor long-term glucose control.',
          preparation: 'No fasting needed.',
          ranges: _hba1cRanges,
          bookedWith: const [
            'Fasting Blood Sugar',
            'Lipid Profile',
            'Kidney Function Test',
          ],
        ),
        _test(
          id: 'fasting-blood-sugar',
          name: 'Fasting Blood Sugar',
          subtitle: 'Glucose (Fasting)',
          price: 99,
          preparation: '8–10 hours fasting required.',
        ),
        _test(
          id: 'pp-blood-sugar',
          name: 'PP Blood Sugar',
          subtitle: 'Glucose (Post Prandial)',
          price: 99,
          preparation: 'Sample collected 2 hours after a meal.',
        ),
        _test(
          id: 'insulin-fasting',
          name: 'Insulin Fasting',
          subtitle: 'Insulin (Fasting)',
          price: 199,
          preparation: '8–10 hours fasting required.',
        ),
        _test(
          id: 'diabetes-lipid-profile',
          name: 'Lipid Profile',
          subtitle: 'Cholesterol, HDL, LDL, TG',
          price: 399,
        ),
        _test(
          id: 'diabetes-kidney-function',
          name: 'Kidney Function Test',
          subtitle: 'Urea, Creatinine, Uric Acid',
          price: 299,
        ),
      ],
    ),
    HealthCategory(
      id: 'thyroid-hormones',
      name: 'Thyroid & Hormones',
      testCount: 18,
      icon: Icons.spa_outlined,
      color: const Color(0xFF69B832),
      tests: [
        _test(
          id: 'tsh',
          name: 'TSH',
          subtitle: 'Thyroid Stimulating Hormone',
          price: 199,
        ),
        _test(
          id: 't3-total',
          name: 'T3 Total',
          subtitle: 'Triiodothyronine',
          price: 199,
        ),
        _test(
          id: 't4-total',
          name: 'T4 Total',
          subtitle: 'Thyroxine',
          price: 199,
        ),
        _test(
          id: 'thyroid-profile-total',
          name: 'Thyroid Profile Total',
          subtitle: 'T3, T4, TSH',
          price: 399,
        ),
        _test(
          id: 'thyroid-profile-free',
          name: 'Thyroid Profile Free',
          subtitle: 'FT3, FT4, TSH',
          price: 499,
        ),
      ],
    ),
    HealthCategory(
      id: 'heart-lipids',
      name: 'Heart & Lipids',
      testCount: 22,
      icon: Icons.favorite_border_rounded,
      color: const Color(0xFFE73A59),
      tests: [
        _test(
          id: 'heart-lipid-profile',
          name: 'Lipid Profile',
          subtitle: 'Cholesterol, HDL, LDL, TG',
          price: 399,
        ),
        _test(
          id: 'cholesterol-total',
          name: 'Cholesterol Total',
          subtitle: 'Total Cholesterol',
          price: 199,
        ),
        _test(
          id: 'hdl-cholesterol',
          name: 'HDL Cholesterol',
          subtitle: 'Good Cholesterol',
          price: 199,
        ),
        _test(
          id: 'ldl-cholesterol',
          name: 'LDL Cholesterol',
          subtitle: 'Bad Cholesterol',
          price: 199,
        ),
        _test(
          id: 'triglycerides',
          name: 'Triglycerides',
          subtitle: 'Blood Fats',
          price: 199,
        ),
      ],
    ),
    HealthCategory(
      id: 'liver-health',
      name: 'Liver Health',
      testCount: 16,
      icon: Icons.eco_outlined,
      color: const Color(0xFFF1A800),
      tests: [
        _test(
          id: 'liver-function-test',
          name: 'Liver Function Test',
          subtitle: 'Bilirubin, SGOT, SGPT, Proteins',
          price: 399,
        ),
        _test(
          id: 'sgot',
          name: 'SGOT',
          subtitle: 'Aspartate Aminotransferase',
          price: 199,
        ),
        _test(
          id: 'sgpt',
          name: 'SGPT',
          subtitle: 'Alanine Aminotransferase',
          price: 199,
        ),
        _test(
          id: 'bilirubin-total',
          name: 'Bilirubin Total',
          subtitle: 'Liver Pigment Test',
          price: 149,
        ),
      ],
    ),
    HealthCategory(
      id: 'kidney-health',
      name: 'Kidney Health',
      testCount: 14,
      icon: Icons.join_inner_rounded,
      color: const Color(0xFFC0378D),
      tests: [
        _test(
          id: 'kidney-function-test',
          name: 'Kidney Function Test',
          subtitle: 'Urea, Creatinine, Uric Acid',
          price: 299,
        ),
        _test(
          id: 'creatinine',
          name: 'Creatinine',
          subtitle: 'Kidney Filtration Marker',
          price: 149,
        ),
        _test(id: 'urea', name: 'Urea', subtitle: 'Blood Urea', price: 149),
        _test(
          id: 'uric-acid',
          name: 'Uric Acid',
          subtitle: 'Joint & Kidney Marker',
          price: 149,
        ),
      ],
    ),
    HealthCategory(
      id: 'vitamins-minerals',
      name: 'Vitamins & Minerals',
      testCount: 20,
      icon: Icons.local_florist_outlined,
      color: const Color(0xFF23A77A),
      tests: [
        _test(
          id: 'vitamin-d',
          name: 'Vitamin D',
          subtitle: '25(OH) Vitamin D',
          price: 499,
        ),
        _test(
          id: 'vitamin-b12',
          name: 'Vitamin B12',
          subtitle: 'Cobalamin',
          price: 399,
        ),
        _test(
          id: 'calcium',
          name: 'Calcium',
          subtitle: 'Bone & Mineral Health',
          price: 199,
        ),
        _test(
          id: 'magnesium',
          name: 'Magnesium',
          subtitle: 'Mineral Balance',
          price: 299,
        ),
      ],
    ),
    HealthCategory(
      id: 'anemia-iron',
      name: 'Anemia & Iron Studies',
      testCount: 22,
      icon: Icons.science_outlined,
      color: const Color(0xFFF47A12),
      tests: [
        _test(
          id: 'anemia-cbc',
          name: 'CBC',
          subtitle: 'Complete Blood Count',
          price: 299,
        ),
        _test(
          id: 'iron-studies',
          name: 'Iron Studies',
          subtitle: 'Iron, TIBC, Ferritin',
          price: 599,
        ),
        _test(
          id: 'ferritin',
          name: 'Ferritin',
          subtitle: 'Iron Storage Marker',
          price: 399,
        ),
        _test(
          id: 'hemoglobin',
          name: 'Hemoglobin',
          subtitle: 'Anemia Screening',
          price: 99,
        ),
      ],
    ),
    HealthCategory(
      id: 'immunity-infection',
      name: 'Immunity & Infection',
      testCount: 15,
      icon: Icons.health_and_safety_outlined,
      color: const Color(0xFF159B8A),
      tests: [
        _test(
          id: 'crp',
          name: 'CRP',
          subtitle: 'C-Reactive Protein',
          price: 399,
        ),
        _test(
          id: 'esr',
          name: 'ESR',
          subtitle: 'Inflammation Marker',
          price: 199,
        ),
        _test(
          id: 'immunity-cbc',
          name: 'CBC',
          subtitle: 'Complete Blood Count',
          price: 299,
        ),
        _test(
          id: 'wbc-count',
          name: 'WBC Count',
          subtitle: 'White Blood Cell Count',
          price: 149,
        ),
      ],
    ),
  ];

  static HealthCategory categoryById(String id) {
    return categories.firstWhere(
      (category) => category.id == id,
      orElse: () => categories.first,
    );
  }

  static HealthTest testById(String id) {
    for (final category in categories) {
      for (final test in category.tests) {
        if (test.id == id) return test;
      }
    }
    return categories.first.tests.first;
  }

  static HealthTest _test({
    required String id,
    required String name,
    required String subtitle,
    required int price,
    String sampleType = 'Blood',
    String? whatIsIt,
    String? whyTake,
    String preparation = 'No special preparation required.',
    List<ReferenceRange>? ranges,
    List<String>? bookedWith,
  }) {
    return HealthTest(
      id: id,
      name: name,
      subtitle: subtitle,
      price: price,
      sampleType: sampleType,
      tags: const ['Blood Test', 'Same-day Reports', 'NABL Labs'],
      whatIsIt: whatIsIt ??
          '$name measures $subtitle to give your doctor a clear view of your current health.',
      whyTakeThisTest: whyTake ??
          'To screen for changes early and support accurate diagnosis and ongoing care.',
      referenceRanges: ranges ?? _standardRanges,
      preparation: preparation,
      oftenBookedWith: bookedWith ??
          const [
            'Complete Blood Count',
            'Lipid Profile',
            'Liver Function Test',
          ],
    );
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
