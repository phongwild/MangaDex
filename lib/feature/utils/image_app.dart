import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageApp extends StatefulWidget {
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

  @override
  State<ImageApp> createState() => _ImageAppState();
}

class _ImageAppState extends State<ImageApp> {
  static final BaseCacheManager customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(hours: 6),
      maxNrOfCacheObjects: 3000,
    ),
  );

  @override
  void dispose() {
    super.dispose();
    // Nếu muốn dọn dẹp cache sau khi widget bị hủy
    // customCacheManager.emptyCache(); // Cân nhắc nếu không cần giữ cache lâu
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      errorWidget: (context, url, error) =>
          widget.errorWidget ??
          const Icon(Icons.broken_image, color: Colors.red),
      placeholder: (context, url) =>
          widget.placeholder ?? LoadingShimmer().loadingCircle(),
      height: widget.height,
      width: widget.width,
      fadeInDuration: const Duration(milliseconds: 300),
      fit: widget.fit,
      cacheManager: customCacheManager,
    );
  }
}
