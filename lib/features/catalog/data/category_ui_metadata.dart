import 'package:dr_swift_diagnostics/core/constants/asset_paths.dart';
import 'package:dr_swift_diagnostics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryUiMeta {
  const CategoryUiMeta({
    required this.icon,
    required this.color,
    this.iconAsset,
  });

  final IconData icon;
  final Color color;
  final String? iconAsset;
}

abstract final class CategoryUiMetadata {
  static const _default = CategoryUiMeta(
    icon: Icons.biotech_outlined,
    color: AppColors.primary,
  );

  static CategoryUiMeta forSlug(String slug) {
    return _bySlug[slug] ?? _default;
  }

  static const _bySlug = <String, CategoryUiMeta>{
    'weakness': CategoryUiMeta(
      icon: Icons.battery_1_bar_rounded,
      color: Color(0xFF8E55F3),
      iconAsset: AssetPaths.categoryVitamins,
    ),
    'fever': CategoryUiMeta(
      icon: Icons.thermostat_rounded,
      color: Color(0xFFE73A59),
      iconAsset: AssetPaths.categoryFever,
    ),
    'pain': CategoryUiMeta(
      icon: Icons.healing_outlined,
      color: Color(0xFFF47A12),
    ),
    'cold': CategoryUiMeta(
      icon: Icons.ac_unit_rounded,
      color: Color(0xFF24B7E5),
    ),
    'cough': CategoryUiMeta(
      icon: Icons.air_rounded,
      color: Color(0xFF159B8A),
    ),
    'sugar': CategoryUiMeta(
      icon: Icons.water_drop_outlined,
      color: Color(0xFF18AA63),
      iconAsset: AssetPaths.categoryDiabetes,
    ),
    'checkup': CategoryUiMeta(
      icon: Icons.fact_check_outlined,
      color: Color(0xFF2487D9),
      iconAsset: AssetPaths.completeHealthCheck,
    ),
    'maleria': CategoryUiMeta(
      icon: Icons.bug_report_outlined,
      color: Color(0xFF69B832),
      iconAsset: AssetPaths.categoryFever,
    ),
    'dengue': CategoryUiMeta(
      icon: Icons.coronavirus_outlined,
      color: Color(0xFFC0378D),
      iconAsset: AssetPaths.categoryFever,
    ),
    'vitamin': CategoryUiMeta(
      icon: Icons.local_florist_outlined,
      color: Color(0xFF23A77A),
      iconAsset: AssetPaths.categoryVitamins,
    ),
  };
}

class ProfileUiMeta {
  const ProfileUiMeta({
    required this.iconAsset,
    required this.color,
    required this.homeTitle,
    required this.description,
    required this.whatIsItFor,
    required this.highlights,
    required this.whoShouldTakeThis,
    required this.preparation,
  });

  final String iconAsset;
  final Color color;
  final String homeTitle;
  final String description;
  final String whatIsItFor;
  final List<String> highlights;
  final String whoShouldTakeThis;
  final List<String> preparation;
}

abstract final class ProfileUiMetadata {
  /// Home-screen carousel order matching `docs/health_profile_flow.png` screen 1.
  static const homeFeaturedSlugs = [
    'drs-diabetic',
    'drs-wellness',
    'drs-check-42',
    'drs-check-72',
  ];

  static ProfileUiMeta forSlug(String slug) {
    return _bySlug[slug] ?? _default;
  }

  static String homeTitleFor(String slug, String fallback) {
    return _bySlug[slug]?.homeTitle ?? fallback;
  }

  static const _default = ProfileUiMeta(
    iconAsset: AssetPaths.completeHealthCheck,
    color: Color(0xFF2487D9),
    homeTitle: 'Health Profile',
    description: 'Curated lab tests from Dr Swift Diagnostics.',
    whatIsItFor: 'Helps screen common health markers in one booking.',
    highlights: const [
      'Curated from real catalog tests',
      'At-home sample collection',
      'Reports in 24 hours',
    ],
    whoShouldTakeThis:
        'Anyone looking for preventive screening or symptom-based testing.',
    preparation: const [
      'Follow fasting guidance on included tests',
      'Drink water before sample collection',
      'Share current medications with the phlebotomist',
    ],
  );

  static const _bySlug = <String, ProfileUiMeta>{
    'drs-diabetic': ProfileUiMeta(
      iconAsset: AssetPaths.diabetesCareProfile,
      color: Color(0xFF18AA63),
      homeTitle: 'Diabetes Care',
      description: 'Monitor blood sugar control with fasting glucose and HbA1c.',
      whatIsItFor:
          'Supports diabetes screening, diagnosis and long-term glucose monitoring.',
      highlights: const [
        'Fasting glucose + HbA1c',
        'Useful for routine diabetes care',
        'Doctor-ready report',
      ],
      whoShouldTakeThis:
          'People with high sugar, family history of diabetes or lifestyle risk factors.',
      preparation: const [
        'Fasting of 8-10 hours required for glucose',
        'Avoid alcohol 24 hours before test',
        'Continue routine medication unless advised',
      ],
    ),
    'drs-check-72': ProfileUiMeta(
      iconAsset: AssetPaths.completeHealthCheck,
      color: Color(0xFF2487D9),
      homeTitle: 'Men 50+ Health',
      description: 'Broad preventive profile covering 13 core wellness tests.',
      whatIsItFor:
          'Screens sugar, thyroid, liver, kidney, lipids, vitamins and inflammation.',
      highlights: const [
        '13 tests in one profile',
        'Ideal annual check-up',
        'Covers major organ systems',
      ],
      whoShouldTakeThis: 'Adults seeking a comprehensive preventive health review.',
      preparation: const [
        'Fasting of 8-10 hours recommended',
        'Avoid heavy exercise before sample',
        'Drink water before collection',
      ],
    ),
    'drs-fever': ProfileUiMeta(
      iconAsset: AssetPaths.feverInfection,
      color: Color(0xFFE73A59),
      homeTitle: 'Fever Panel',
      description: 'Fever workup including dengue, malaria and infection markers.',
      whatIsItFor:
          'Helps identify common causes of fever such as dengue, malaria and typhoid.',
      highlights: const [
        'Infection-focused panel',
        'Useful during acute fever',
        'Rapid and lab-based tests combined',
      ],
      whoShouldTakeThis:
          'Anyone with persistent fever, chills, body pain or recent travel.',
      preparation: const [
        'No fasting required unless advised',
        'Note fever duration and symptoms',
        'Stay hydrated before sample collection',
      ],
    ),
    'drs-check-42': ProfileUiMeta(
      iconAsset: AssetPaths.heartHealthProfile,
      color: Color(0xFFE9427A),
      homeTitle: 'Women Health',
      description: 'Mid-size wellness profile with sugar, thyroid and organ markers.',
      whatIsItFor:
          'Tracks metabolic, thyroid, liver and kidney health in one visit.',
      highlights: const [
        '8 essential tests',
        'Good for routine monitoring',
        'Includes urine screening',
      ],
      whoShouldTakeThis:
          'Adults with fatigue, lifestyle risks or annual preventive goals.',
      preparation: const [
        'Fasting of 8-10 hours recommended',
        'Morning sample preferred',
        'Bring medication list if applicable',
      ],
    ),
    'drs-wellness': ProfileUiMeta(
      iconAsset: AssetPaths.thyroidProfile,
      color: Color(0xFF8E55F3),
      homeTitle: 'Thyroid Profile',
      description: 'Core wellness markers for heart, liver, kidney and thyroid.',
      whatIsItFor:
          'Supports preventive screening for common chronic conditions.',
      highlights: const [
        'Includes HbA1c and lipid profile',
        'TSH for thyroid screening',
        'Balanced preventive panel',
      ],
      whoShouldTakeThis:
          'Anyone building a baseline for long-term health tracking.',
      preparation: const [
        'Fasting may be required for some included tests',
        'Avoid alcohol 24 hours before test',
        'Continue routine medication unless advised',
      ],
    ),
    'drs-ortho': ProfileUiMeta(
      iconAsset: AssetPaths.categoryHeart,
      color: Color(0xFFF1A800),
      homeTitle: 'Ortho Care',
      description: 'Joint and bone health screening with vitamin D and RA factor.',
      whatIsItFor:
          'Helps evaluate joint pain, inflammation and bone health markers.',
      highlights: const [
        'Vitamin D + RA factor',
        'Useful for joint pain workup',
        'Includes CBC and ESR',
      ],
      whoShouldTakeThis:
          'People with joint pain, stiffness, bone pain or arthritis suspicion.',
      preparation: const [
        'No fasting required',
        'Note joint symptoms and duration',
        'Avoid strenuous activity before sample if in acute pain',
      ],
    ),
    'drs-vital': ProfileUiMeta(
      iconAsset: AssetPaths.categoryFever,
      color: Color(0xFF159B8A),
      homeTitle: 'Vital Panel',
      description: 'Vital infection panel similar to the fever profile.',
      whatIsItFor:
          'Screens dengue, malaria, typhoid and general infection markers.',
      highlights: const [
        'Acute illness focused',
        'Combines rapid and lab tests',
        'Useful during seasonal outbreaks',
      ],
      whoShouldTakeThis:
          'Patients with fever, chills, headache or suspected tropical infections.',
      preparation: const [
        'No fasting required',
        'Share travel and symptom history',
        'Stay hydrated before collection',
      ],
    ),
  };
}
