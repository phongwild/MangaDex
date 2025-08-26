import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformanceUtils {
  // Debounce function to prevent excessive rebuilds
  static void debounce(
    String tag,
    Duration duration,
    VoidCallback action, {
    Map<String, Timer>? timers,
  }) {
    timers ??= {};
    timers[tag]?.cancel();
    timers[tag] = Timer(duration, action);
  }

  // Throttle function to limit function calls
  static void throttle(
    String tag,
    Duration duration,
    VoidCallback action, {
    Map<String, DateTime>? lastRun,
  }) {
    lastRun ??= {};
    final now = DateTime.now();
    if (lastRun[tag] == null || 
        now.difference(lastRun[tag]!).inMilliseconds >= duration.inMilliseconds) {
      lastRun[tag] = now;
      action();
    }
  }

  // Measure widget build time
  static T measureBuildTime<T>(String widgetName, T Function() builder) {
    if (!kDebugMode) return builder();
    
    final stopwatch = Stopwatch()..start();
    final result = builder();
    stopwatch.stop();
    
    if (stopwatch.elapsedMilliseconds > 16) {
      debugPrint('⚠️ $widgetName build took ${stopwatch.elapsedMilliseconds}ms');
    }
    
    return result;
  }

  // Check if device is low-end
  static bool isLowEndDevice() {
    // This is a simple heuristic, you might want to implement
    // more sophisticated detection based on actual device specs
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.devicePixelRatio < 2.0;
  }

  // Get optimized animation duration based on device performance
  static Duration getAnimationDuration({
    Duration normal = const Duration(milliseconds: 300),
    Duration fast = const Duration(milliseconds: 150),
  }) {
    return isLowEndDevice() ? fast : normal;
  }

  // Optimize image quality based on device
  static FilterQuality getImageQuality() {
    return isLowEndDevice() ? FilterQuality.low : FilterQuality.medium;
  }
}

// Extension for easier widget performance optimization
extension PerformanceOptimization on Widget {
  // Wrap widget with RepaintBoundary for better performance
  Widget withRepaintBoundary() {
    return RepaintBoundary(child: this);
  }

  // Add performance monitoring in debug mode
  Widget withPerformanceMonitoring(String name) {
    if (!kDebugMode) return this;
    
    return Builder(
      builder: (context) {
        return PerformanceUtils.measureBuildTime(
          name,
          () => this,
        );
      },
    );
  }
}

// Timer utility for debouncing and throttling
class Timer {
  final Duration duration;
  final VoidCallback callback;
  Timer? _timer;

  Timer(this.duration, this.callback) {
    _timer = Future.delayed(duration, callback).asStream().listen((_) {}).asFuture() as Timer?;
  }

  void cancel() {
    _timer = null;
  }
}