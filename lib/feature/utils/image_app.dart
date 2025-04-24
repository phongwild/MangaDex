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
          placeholder ?? LoadingShimmer().loadingCircle(),
      height: height,
      width: width,
      fadeInDuration: const Duration(milliseconds: 300),
      fit: fit,
      cacheManager: customCacheManager,
    );
  }
}
