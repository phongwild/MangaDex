import 'package:app/core/app_log.dart';
import 'package:app/core/performance_config.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dùng luôn customCacheManager bên ImageApp
final cacheManager = CacheManager(
  Config(
    'customCacheKey',
    stalePeriod: PerformanceConfig.imageCacheStalePeriod,
    maxNrOfCacheObjects: PerformanceConfig.maxCacheObjects,
    repo: JsonCacheInfoRepository(databaseName: 'image_manga'),
    fileService: HttpFileService(),
    // Thêm các tùy chọn tối ưu hóa
    fileSystem: IOFileSystem(key: 'customCacheKey'),
    maxSize: PerformanceConfig.maxImageCacheSize * 1024 * 1024,
  ),
);

Future<void> clearImageCacheIfNeeded() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    final lastClear = prefs.getInt('last_image_cache_clear') ?? 0;
    final lastClearTime = DateTime.fromMillisecondsSinceEpoch(lastClear);
    dlog('🕒 Lần xoá gần nhất: $lastClearTime');

    // Sử dụng cấu hình từ PerformanceConfig
    if (nowMillis - lastClear >= PerformanceConfig.imageCacheCleanupInterval.inMilliseconds) {
      await cacheManager.emptyCache(); // xoá hết ảnh cũ
      await prefs.setInt('last_image_cache_clear', nowMillis);
      dlog('✨ Đã xoá image cache sau ${PerformanceConfig.imageCacheCleanupInterval.inHours}h');
    }
  } catch (e) {
    dlog('Lỗi khi xoá cache: $e');
  }
}

Future<void> clearAllCacheFolder() async {
  try {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      // Chỉ xóa các file cũ hơn 1 ngày để tránh xóa cache mới
      final now = DateTime.now();
      final files = cacheDir.listSync();
      int deletedCount = 0;
      
      for (final file in files) {
        if (file is File) {
          try {
            final stat = file.statSync();
            if (now.difference(stat.modified).inDays > 1) {
              file.deleteSync();
              deletedCount++;
            }
          } catch (e) {
            // Bỏ qua file không thể xóa
          }
        }
      }
      
      dlog("Đã xoá $deletedCount file cache cũ");
    } else {
      dlog("Cache folder không tồn tại");
    }
  } catch (e) {
    dlog("❌ Lỗi khi xoá cache folder: $e");
  }
}

// Thêm function để xóa cache theo kích thước
Future<void> clearCacheIfSizeExceeds(int maxSizeMB) async {
  try {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      final files = cacheDir.listSync();
      int totalSize = 0;
      final fileSizes = <File, int>{};
      
      // Tính tổng kích thước cache
      for (final file in files) {
        if (file is File) {
          try {
            final size = file.lengthSync();
            totalSize += size;
            fileSizes[file] = size;
          } catch (e) {
            // Bỏ qua file không thể đọc
          }
        }
      }
      
      // Nếu vượt quá giới hạn, xóa các file cũ nhất
      if (totalSize > maxSizeMB * 1024 * 1024) {
        final sortedFiles = fileSizes.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));
        
        int deletedSize = 0;
        for (final entry in sortedFiles) {
          if (deletedSize < totalSize - (maxSizeMB * 1024 * 1024)) {
            try {
              entry.key.deleteSync();
              deletedSize += entry.value;
            } catch (e) {
              // Bỏ qua file không thể xóa
            }
          }
        }
        
        dlog("Đã xoá ${deletedSize ~/ (1024 * 1024)}MB cache để giảm xuống dưới ${maxSizeMB}MB");
      }
    }
  } catch (e) {
    dlog("❌ Lỗi khi xoá cache theo kích thước: $e");
  }
}

// Function để xóa cache theo cấu hình
Future<void> clearCacheByConfig() async {
  await clearCacheIfSizeExceeds(PerformanceConfig.maxImageCacheSize);
}
