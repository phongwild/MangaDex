import 'package:app/core/app_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Dùng luôn customCacheManager bên ImageApp
final cacheManager = CacheManager(
  Config(
    'customCacheKey',
    stalePeriod: const Duration(hours: 6),
    maxNrOfCacheObjects: 3000,
  ),
);

Future<void> clearImageCacheIfNeeded() async {
  final prefs = await SharedPreferences.getInstance();
  final nowMillis = DateTime.now().millisecondsSinceEpoch;
  final lastClear = prefs.getInt('last_image_cache_clear') ?? 0;

  // Nếu đã hơn 24h kể từ lần xoá trước:
  if (nowMillis - lastClear >= const Duration(hours: 6).inMilliseconds) {
    await cacheManager.emptyCache(); // xoá hết ảnh cũ
    await prefs.setInt('last_image_cache_clear', nowMillis);
    dlog('✨ Đã xoá image cache sau 6h');
  }
}
