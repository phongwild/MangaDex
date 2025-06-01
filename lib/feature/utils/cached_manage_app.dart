import 'package:app/core/app_log.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dùng luôn customCacheManager bên ImageApp
final cacheManager = CacheManager(
  Config(
    'customCacheKey',
    stalePeriod: const Duration(hours: 6),
    maxNrOfCacheObjects: 200, // giảm xuống cho nhẹ
    repo: JsonCacheInfoRepository(databaseName: 'image_manga'),
    fileService: HttpFileService(),
  ),
);

Future<void> clearImageCacheIfNeeded() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    final lastClear = prefs.getInt('last_image_cache_clear') ?? 0;
    final lastClearTime = DateTime.fromMillisecondsSinceEpoch(lastClear);
    dlog('🕒 Lần xoá gần nhất: $lastClearTime');

    // Nếu đã hơn 24h kể từ lần xoá trước:
    if (nowMillis - lastClear >= const Duration(hours: 6).inMilliseconds) {
      await cacheManager.emptyCache(); // xoá hết ảnh cũ
      await prefs.setInt('last_image_cache_clear', nowMillis);
      dlog('✨ Đã xoá image cache sau 6h');
    }
  } catch (e) {
    dlog('Lỗi khi xoá cache: $e');
  }
}

Future<void> clearAllCacheFolder() async {
  try {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
      dlog("Đã xoá toàn bộ cache folder: ${cacheDir.path}");
    } else {
      dlog("Cache folder không tồn tại");
    }
  } catch (e) {
    dlog("❌ Lỗi khi xoá cache folder: $e");
  }
}
