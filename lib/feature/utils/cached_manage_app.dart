import 'package:app/core/app_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Optimized cache manager for low-end devices
final cacheManager = CacheManager(
  Config(
    'customCacheKey',
    stalePeriod: const Duration(hours: 3), // Reduced for low-end devices
    maxNrOfCacheObjects: kReleaseMode ? 100 : 200, // Lower cache size in production
    repo: JsonCacheInfoRepository(databaseName: 'image_manga'),
    fileService: HttpFileService(),
  ),
);

Future<void> clearImageCacheIfNeeded() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    final lastClear = prefs.getInt('last_image_cache_clear') ?? 0;
    
    // More aggressive cache clearing for low-end devices
    final clearInterval = kReleaseMode 
        ? const Duration(hours: 3).inMilliseconds  // More frequent in production
        : const Duration(hours: 6).inMilliseconds; // Less frequent in debug
    
    if (!kDebugMode) {
      final lastClearTime = DateTime.fromMillisecondsSinceEpoch(lastClear);
      dlog('🕒 Lần xoá gần nhất: $lastClearTime');
    }

    // Clear cache if needed
    if (nowMillis - lastClear >= clearInterval) {
      await cacheManager.emptyCache();
      await prefs.setInt('last_image_cache_clear', nowMillis);
      if (!kDebugMode) {
        dlog('✨ Đã xoá image cache sau ${clearInterval ~/ (1000 * 60 * 60)}h');
      }
    }
  } catch (e) {
    if (!kDebugMode) {
      dlog('Lỗi khi xoá cache: $e');
    }
  }
}

// Optimized cache clearing with better memory management
Future<void> clearAllCacheFolder() async {
  try {
    final cacheDir = await getTemporaryDirectory();
    if (await cacheDir.exists()) {
      // Use asynchronous deletion for better performance
      await cacheDir.delete(recursive: true);
      if (!kDebugMode) {
        dlog("Đã xoá toàn bộ cache folder: ${cacheDir.path}");
      }
    } else {
      if (!kDebugMode) {
        dlog("Cache folder không tồn tại");
      }
    }
  } catch (e) {
    if (!kDebugMode) {
      dlog("❌ Lỗi khi xoá cache folder: $e");
    }
  }
}

// New function to optimize cache size for low-end devices
Future<void> optimizeCacheForLowEndDevice() async {
  try {
    final cacheInfo = await cacheManager.getFileFromCache('cache_size_check');
    if (cacheInfo == null) {
      // First time setup - clear any existing cache
      await cacheManager.emptyCache();
      
      // Store a marker file
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('cache_optimized', true);
      
      if (!kDebugMode) {
        dlog('🚀 Cache đã được tối ưu cho thiết bị yếu');
      }
    }
  } catch (e) {
    if (!kDebugMode) {
      dlog('Lỗi khi tối ưu cache: $e');
    }
  }
}
