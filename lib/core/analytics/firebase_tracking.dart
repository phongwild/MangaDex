import 'package:app/core/analytics/analytics_logger.dart';
import 'package:flutter/material.dart';

class FirebaseTracking extends AnalyticsLogger {
  @override
  void logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      //   await FirebaseAnalytics.instance
      //       .logEvent(name: name, parameters: parameters);

      //   dlog('Result logEvent $name: $parameters');
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
