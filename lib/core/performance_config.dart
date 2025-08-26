/// Cấu hình tối ưu hóa performance cho thiết bị yếu
class PerformanceConfig {
  // Cache settings
  static const int maxImageCacheSize = 50; // MB
  static const int maxCacheObjects = 100;
  static const Duration imageCacheStalePeriod = Duration(hours: 4);
  
  // UI settings
  static const Duration optimalAnimationDuration = Duration(milliseconds: 200);
  static const Duration optimalFadeDuration = Duration(milliseconds: 150);
  static const FilterQuality optimalImageQuality = FilterQuality.medium;
  
  // List settings
  static const int optimalListLimit = 20;
  static const int optimalCacheExtent = 300;
  static const int optimalMemoryCacheExtent = 200;
  
  // Cleanup intervals
  static const Duration memoryCleanupInterval = Duration(minutes: 5);
  static const Duration cacheCleanupInterval = Duration(hours: 2);
  static const Duration imageCacheCleanupInterval = Duration(hours: 4);
  
  // Network settings
  static const Duration networkToastInterval = Duration(seconds: 10);
  static const Duration appStartupDelay = Duration(milliseconds: 100);
  
  // Scroll settings
  static const bool enableRepaintBoundaries = true;
  static const bool enableAutomaticKeepAlives = false;
  static const bool enableRepaintBoundariesInLists = false;
  
  // Image loading settings
  static const bool enableImageFadeIn = true;
  static const bool enableImageFadeOut = true;
  static const bool enableImagePlaceholder = true;
  
  // Debug settings
  static const bool enablePerformanceLogging = false;
  static const bool enableMemoryMonitoring = false;
  
  /// Kiểm tra xem có nên bật tối ưu hóa cho thiết bị yếu không
  static bool shouldEnableLowEndOptimizations() {
    // Logic để detect thiết bị yếu
    // Có thể mở rộng thêm logic phức tạp hơn
    return true; // Mặc định bật cho tất cả thiết bị
  }
  
  /// Lấy cấu hình tối ưu hóa dựa trên loại thiết bị
  static PerformanceConfig getOptimizedConfig() {
    if (shouldEnableLowEndOptimizations()) {
      return PerformanceConfig();
    }
    return PerformanceConfig();
  }
}