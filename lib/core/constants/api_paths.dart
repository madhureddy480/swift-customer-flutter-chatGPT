abstract final class ApiPaths {
  static const authExchange = '/api/auth/firebase/exchange';
  static const me = '/api/me';
  static const catalogCategories = '/api/catalog/categories';
  static const catalogTests = '/api/catalog/tests';
  static const catalogPackages = '/api/catalog/packages';

  // DrSwift-CMS public catalog (used when USE_CATALOG_API=true).
  static const cmsCatalog = '/api/v1/public/catalog';
  static const cmsTestBySlug = '/api/v1/public/catalog/tests';
  static const cmsHeroCarousel = '/api/v1/public/hero-carousel';
  static const cart = '/api/cart';
  static const checkoutQuote = '/api/checkout/quote';
  static const checkoutPlaceOrder = '/api/checkout/place-order';
  static const orders = '/api/orders';
  static const family = '/api/family';
  static const reports = '/api/reports';
  static const reportsSummary = '/api/reports/summary';
}
