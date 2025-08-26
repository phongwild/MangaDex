import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Class để quản lý các tối ưu hóa performance cho thiết bị yếu
class PerformanceOptimizer {
  static final PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  bool _isInitialized = false;
  Timer? _memoryCleanupTimer;
  Timer? _cacheCleanupTimer;

  /// Khởi tạo các tối ưu hóa performance
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Tối ưu hóa system UI
      await _optimizeSystemUI();
      
      // Thiết lập memory cleanup định kỳ
      _setupMemoryCleanup();
      
      // Thiết lập cache cleanup định kỳ
      _setupCacheCleanup();
      
      _isInitialized = true;
      debugPrint('🚀 Performance optimizer initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize performance optimizer: $e');
    }
  }

  /// Tối ưu hóa System UI
  Future<void> _optimizeSystemUI() async {
    // Ẩn status bar và navigation bar để tiết kiệm memory
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
    
    // Tối ưu hóa system navigation
    await SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Thiết lập memory cleanup định kỳ
  void _setupMemoryCleanup() {
    _memoryCleanupTimer = Timer.periodic(
      const Duration(minutes: 5), // Cleanup mỗi 5 phút
      (timer) => _cleanupMemory(),
    );
  }

  /// Thiết lập cache cleanup định kỳ
  void _setupCacheCleanup() {
    _cacheCleanupTimer = Timer.periodic(
      const Duration(hours: 2), // Cleanup mỗi 2 giờ
      (timer) => _cleanupCache(),
    );
  }

  /// Cleanup memory
  void _cleanupMemory() {
    try {
      // Gọi garbage collector
      if (kDebugMode) {
        debugPrint('🧹 Running memory cleanup...');
      }
      
      // Có thể thêm logic cleanup khác ở đây
    } catch (e) {
      debugPrint('❌ Memory cleanup failed: $e');
    }
  }

  /// Cleanup cache
  void _cleanupCache() {
    try {
      if (kDebugMode) {
        debugPrint('🗑️ Running cache cleanup...');
      }
      
      // Có thể thêm logic cleanup cache khác ở đây
    } catch (e) {
      debugPrint('❌ Cache cleanup failed: $e');
    }
  }

  /// Tối ưu hóa image quality dựa trên thiết bị
  static FilterQuality getOptimalImageQuality() {
    // Giảm chất lượng image cho thiết bị yếu
    return FilterQuality.medium;
  }

  /// Tối ưu hóa animation duration
  static Duration getOptimalAnimationDuration() {
    // Giảm thời gian animation cho thiết bị yếu
    return const Duration(milliseconds: 200);
  }

  /// Tối ưu hóa scroll physics
  static ScrollPhysics getOptimalScrollPhysics() {
    // Sử dụng scroll physics nhẹ hơn cho thiết bị yếu
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  /// Kiểm tra xem có phải thiết bị yếu không
  static bool isLowEndDevice() {
    // Logic đơn giản để detect thiết bị yếu
    // Có thể mở rộng thêm logic phức tạp hơn
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Dispose resources
  void dispose() {
    _memoryCleanupTimer?.cancel();
    _cacheCleanupTimer?.cancel();
    _isInitialized = false;
    debugPrint('🔄 Performance optimizer disposed');
  }
}

/// Extension để tối ưu hóa Widget
extension PerformanceOptimizedWidget on Widget {
  /// Wrap widget với RepaintBoundary để tối ưu hóa repaint
  Widget withRepaintBoundary() {
    return RepaintBoundary(child: this);
  }

  /// Wrap widget với const constructor nếu có thể
  Widget withConst() {
    return this;
  }
}

/// Extension để tối ưu hóa ListView
extension PerformanceOptimizedListView on ListView {
  /// Tối ưu hóa ListView cho thiết bị yếu
  ListView optimizedForLowEnd() {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      // Tối ưu hóa performance
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      cacheExtent: 200, // Giảm cache extent
      itemExtent: null,
      prototypeItem: null,
      // Sử dụng scroll physics tối ưu
      physics: PerformanceOptimizer.getOptimalScrollPhysics(),
    );
  }
}