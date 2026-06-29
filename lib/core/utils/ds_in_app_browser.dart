import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [uri] inside the app using the platform in-app browser.
///
/// iOS: [SFSafariViewController] (Safari sheet with Done button — Apple-recommended).
/// Android: Chrome Custom Tabs (browser chrome inside the app).
///
/// This is the same pattern used by Amex, Wells Fargo, etc. Apple App Store
/// allows it for viewing reports, help, and authenticated web content.
Future<bool> openDsInAppBrowser(Uri uri) async {
  if (!uri.hasScheme) {
    return false;
  }

  if (!await canLaunchUrl(uri)) {
    return false;
  }

  if (!kIsWeb && await supportsLaunchMode(LaunchMode.inAppBrowserView)) {
    return launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(
        showTitle: true,
      ),
    );
  }

  // Web / unsupported platforms: new browser tab.
  return launchUrl(
    uri,
    mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    webOnlyWindowName: kIsWeb ? '_blank' : null,
  );
}
