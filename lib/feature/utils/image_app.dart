import 'package:app/core/performance_config.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/utils/cached_manage_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageApp extends StatelessWidget {
  const ImageApp({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.errorWidget,
    this.placeholder,
    this.fit,
  });

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final Widget? placeholder;
  static final CacheManager customCacheManager = cacheManager;
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.broken_image),
      placeholder: (context, url) =>
          placeholder ?? const LoadingShimmer().loadingCircle(),
      height: height,
      width: width,
      // Sử dụng cấu hình từ PerformanceConfig
      fadeInDuration: PerformanceConfig.optimalFadeDuration,
      fadeOutDuration: const Duration(milliseconds: 100),
      fit: fit,
      cacheManager: customCacheManager,
      // Thêm các tùy chọn tối ưu hóa
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      // Sử dụng cấu hình từ PerformanceConfig
      filterQuality: PerformanceConfig.optimalImageQuality,
      // Sử dụng placeholder đơn giản hơn
      placeholderFadeInDuration: const Duration(milliseconds: 100),
      // Tối ưu hóa memory
      maxWidthDiskCache: width?.toInt(),
      maxHeightDiskCache: height?.toInt(),
    );
  }
}
