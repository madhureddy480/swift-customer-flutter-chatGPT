abstract final class RoutePaths {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';

  static const tests = '/tests';
  static const categories = '/categories';
  static const categoryTests = '/categories/:slug';
  static const testDetail = '/tests/:id';
  static const profiles = '/profiles';
  static const healthProfile = '/profiles/:slug';
  static const healthProfileTests = '/profiles/:slug/tests';
  static const healthProfileMoreInfo = '/profiles/:slug/more-info';
  static const healthProfileAdded = '/profiles/:slug/added';

  static const reports = '/reports';
  static const health = '/health';
  static const account = '/account';

  static const cart = '/cart/:slug';
  static const book = '/book/:slug';
  static const checkout = '/checkout/:slug';
  static const orders = '/orders/:slug';
}
