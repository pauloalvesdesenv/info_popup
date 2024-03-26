import 'dart:io';

import 'package:in_app_review/in_app_review.dart' as iar;
import 'package:url_launcher/url_launcher.dart';

class StoreReviewService {
  static Future<void> open() async {
    if (await iar.InAppReview.instance.isAvailable()) {
      iar.InAppReview.instance.requestReview();
    } else {
      final url = Platform.isAndroid
          ? 'https://play.google.com/store/apps/details?id=com.m2.acoplus'
          : 'https://apps.apple.com/fi/app/aco_plus-and-planner-2024/id6475045778';
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
