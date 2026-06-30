/// Canonical asset paths — all icons from [assets/icons].
abstract final class AssetPaths {
  static const logo = 'assets/images/logo.png';

  // Health tab care carousel
  static const healthCarousel1 = 'assets/images/health_carousel/carousel_1.png';
  static const healthCarousel2 = 'assets/images/health_carousel/carousel_2.png';
  static const healthCarousel3 = 'assets/images/health_carousel/carousel_3.png';
  static const onboardingHealthProfiles =
      'assets/onboarding/health_profiles.png';
  static const onboardingFamily = 'assets/onboarding/family_account.png';
  static const onboardingResultsInsights =
      'assets/onboarding/results_insights.png';

  // Health profile grid cards
  static const diabeticProfileCard = 'assets/images/diabetes_profile_card.png';
  static const check72ProfileCard =
      'assets/images/complete_health_profile_card.png';
  static const feverProfileCard = 'assets/images/infection_profile_card.png';
  static const check42ProfileCard = 'assets/images/cardiac_profile_card.png';
  static const wellnessProfileCard = 'assets/images/wellness_profile_card.png';
  static const orthoProfileCard = 'assets/images/bone_joint_profile_card.png';
  static const vitalProfileCard = 'assets/images/heart_health_profile_card.png';
  static const healthProfilesHero = 'assets/images/health_profiles_hero.png';

  static String healthProfileCardForSlug(String slug) {
    return switch (slug) {
      'drs-diabetic' => diabeticProfileCard,
      'drs-check-72' => check72ProfileCard,
      'drs-fever' => feverProfileCard,
      'drs-check-42' => check42ProfileCard,
      'drs-wellness' => wellnessProfileCard,
      'drs-ortho' => orthoProfileCard,
      'drs-vital' => vitalProfileCard,
      _ => check72ProfileCard,
    };
  }

  static const iconsBase = 'assets/icons';

  // Onboarding & splash feature icons
  static const bookTests = '$iconsBase/book-tests-icon.svg';
  static const downloadAnytime = '$iconsBase/download-anytime-icon.svg';
  static const compareHistory = '$iconsBase/compare-history-icon.svg';
  static const addFamily = '$iconsBase/add-family-member.svg';
  static const accurateResults = '$iconsBase/accurate-results.svg';
  static const patientFirst = '$iconsBase/patient-first.svg';
  static const trackReports = '$iconsBase/track-reports-icon.svg';
  static const downloadReport = '$iconsBase/download-report.svg';

  // Navigation
  static const navFlask = '$iconsBase/flask.svg';
  static const navReports = '$iconsBase/track-reports.svg';
  static const navGraph = '$iconsBase/graph.svg';
  static const navPerson = '$iconsBase/person.svg';

  // Health profiles
  static const diabetesCareProfile = '$iconsBase/diabetes_care_profile.svg';
  static const heartHealthProfile = '$iconsBase/heart-health-profile.svg';
  static const completeHealthCheck = '$iconsBase/complete_health_check.svg';
  static const thyroidProfile = '$iconsBase/thyroid.svg';

  // Categories
  static const categoryDiabetes = '$iconsBase/category-diabetes-care.svg';
  static const categoryHeart = '$iconsBase/category-heart-health.svg';
  static const categoryThyroid = '$iconsBase/category-thyroid-care.svg';
  static const categoryLiver = '$iconsBase/category-liver-health.svg';
  static const categoryKidney = '$iconsBase/category-kidney-health.svg';
  static const categoryVitamins = '$iconsBase/category-vitamins-nutrition.svg';
  static const categoryFever = '$iconsBase/category-fever-infection.svg';

  // Misc
  static const clock = '$iconsBase/clock.svg';
  static const flask = '$iconsBase/flask.svg';
  static const graph = '$iconsBase/graph.svg';
  static const heartHealth = '$iconsBase/heart_health.svg';
  static const liver = '$iconsBase/liver.svg';
  static const kidney = '$iconsBase/kidney.svg';
  static const feverInfection = '$iconsBase/fever_infection.svg';
  static const vitamins = '$iconsBase/vitamins_nutrition.svg';
  static const diabetesCare = '$iconsBase/diabetes_care.svg';

  static String icon(String name) => '$iconsBase/$name.svg';
}
