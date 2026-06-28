/// Canonical asset paths — all icons from [assets/icons].
abstract final class AssetPaths {
  static const logo = 'assets/images/logo.png';
  static const onboardingHealthProfiles =
      'assets/onboarding/health_profiles.png';
  static const onboardingFamily = 'assets/onboarding/family_account.png';
  static const onboardingResultsInsights =
      'assets/onboarding/results_insights.png';
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
