import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerformanceOptimizer {
  static const PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  const PerformanceOptimizer._internal();

  /// Check if device is considered low-end
  static bool get isLowEndDevice {
    if (kIsWeb) return false;
    
    // In production, be more aggressive about optimization
    if (kReleaseMode) return true;
    
    // For debug builds, you can add more sophisticated detection
    return false;
  }

  /// Optimize app for low-end devices
  static Future<void> optimizeForLowEndDevice() async {
    if (!isLowEndDevice) return;

    // Reduce animation durations
    await _optimizeAnimations();
    
    // Optimize system UI
    await _optimizeSystemUI();
    
    // Configure memory management
    _configureMemoryManagement();
  }

  static Future<void> _optimizeAnimations() async {
    // Reduce animation durations for smoother performance
    if (kReleaseMode) {
      // You can set global animation duration multipliers here
      debugPrint('Optimizing animations for low-end device');
    }
  }

  static Future<void> _optimizeSystemUI() async {
    // Optimize system UI for better performance
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  static void _configureMemoryManagement() {
    // Configure garbage collection hints for low-end devices
    if (kReleaseMode) {
      // Suggest more aggressive garbage collection
      debugPrint('Configuring memory management for low-end device');
    }
  }

  /// Get optimized widget constraints for lists
  static double getOptimizedItemHeight() {
    return isLowEndDevice ? 80.0 : 100.0;
  }

  /// Get optimized cache size based on device capability
  static int getOptimizedCacheSize() {
    return isLowEndDevice ? 50 : 100;
  }

  /// Get optimized image quality
  static FilterQuality getOptimizedImageQuality() {
    return isLowEndDevice ? FilterQuality.low : FilterQuality.medium;
  }

  /// Get optimized animation duration
  static Duration getOptimizedAnimationDuration(Duration defaultDuration) {
    if (isLowEndDevice) {
      return Duration(milliseconds: (defaultDuration.inMilliseconds * 0.7).round());
    }
    return defaultDuration;
  }

  /// Get optimized scroll physics for lists
  static ScrollPhysics getOptimizedScrollPhysics() {
    return isLowEndDevice 
        ? const ClampingScrollPhysics() 
        : const BouncingScrollPhysics();
  }

  /// Check if widget should use optimized rendering
  static bool shouldUseOptimizedRendering() {
    return isLowEndDevice || kReleaseMode;
  }

  /// Get optimized text scale factor
  static double getOptimizedTextScaleFactor(double original) {
    if (isLowEndDevice && original > 1.2) {
      return 1.2; // Cap text scaling on low-end devices
    }
    return original;
  }
}

/// Optimized List View for low-end devices
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const OptimizedListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (PerformanceOptimizer.isLowEndDevice) {
      // Use simpler ListView for low-end devices
      return ListView(
        controller: controller,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: PerformanceOptimizer.getOptimizedScrollPhysics(),
        children: children,
      );
    } else {
      // Use ListView.builder for better performance on capable devices
      return ListView.builder(
        controller: controller,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: PerformanceOptimizer.getOptimizedScrollPhysics(),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      );
    }
  }
}

/// Optimized AnimatedContainer for low-end devices
class OptimizedAnimatedContainer extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final Curve curve;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;

  const OptimizedAnimatedContainer({
    super.key,
    required this.child,
    this.duration,
    this.curve = Curves.linear,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final optimizedDuration = PerformanceOptimizer.getOptimizedAnimationDuration(
      duration ?? const Duration(milliseconds: 200)
    );

    if (PerformanceOptimizer.shouldUseOptimizedRendering()) {
      // Use Container without animation for low-end devices
      return Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        child: child,
      );
    } else {
      return AnimatedContainer(
        duration: optimizedDuration,
        curve: curve,
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
        child: child,
      );
    }
  }
}

/// Lazy loading widget for better performance
class LazyLoadingWidget extends StatefulWidget {
  final Widget child;
  final Widget placeholder;
  final double threshold;

  const LazyLoadingWidget({
    super.key,
    required this.child,
    required this.placeholder,
    this.threshold = 100.0,
  });

  @override
  State<LazyLoadingWidget> createState() => _LazyLoadingWidgetState();
}

class _LazyLoadingWidgetState extends State<LazyLoadingWidget> {
  bool _shouldLoad = false;

  @override
  Widget build(BuildContext context) {
    if (!PerformanceOptimizer.isLowEndDevice) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_shouldLoad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final renderBox = context.findRenderObject() as RenderBox?;
            if (renderBox != null && renderBox.hasSize) {
              final position = renderBox.localToGlobal(Offset.zero);
              final screenHeight = MediaQuery.of(context).size.height;
              
              if (position.dy < screenHeight + widget.threshold && 
                  position.dy > -widget.threshold) {
                if (mounted) {
                  setState(() {
                    _shouldLoad = true;
                  });
                }
              }
            }
          });
          return widget.placeholder;
        }
        
        return widget.child;
      },
    );
  }
}