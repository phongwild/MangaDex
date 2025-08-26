import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/utils/cached_manage_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
    this.enableMemCache = true,
    this.lowResUrl,
    this.quality = FilterQuality.medium,
  });

  final String imageUrl;
  final String? lowResUrl; // Optional low-resolution version for fast loading
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final Widget? placeholder;
  final bool enableMemCache;
  final FilterQuality quality;
  
  static final CacheManager customCacheManager = cacheManager;
  
  @override
  Widget build(BuildContext context) {
    // Use lower quality images on low-end devices in release mode
    final shouldOptimize = kReleaseMode;
    final optimizedFit = fit ?? BoxFit.cover;
    
    return CachedNetworkImage(
      imageUrl: imageUrl,
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.broken_image, size: 48),
      placeholder: (context, url) => _buildOptimizedPlaceholder(),
      height: height,
      width: width,
      // Optimized fade duration for low-end devices
      fadeInDuration: shouldOptimize 
          ? const Duration(milliseconds: 150) 
          : const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      fit: optimizedFit,
      cacheManager: customCacheManager,
      
      // Performance optimizations
      filterQuality: quality,
      memCacheWidth: shouldOptimize && width != null ? (width! * 2).round() : null,
      memCacheHeight: shouldOptimize && height != null ? (height! * 2).round() : null,
      
      // Progressive loading for better perceived performance
      progressIndicatorBuilder: shouldOptimize 
          ? null 
          : (context, url, downloadProgress) => _buildProgressIndicator(downloadProgress),
      
      // Optimized error handling
      errorListener: (error) {
        if (!kReleaseMode) {
          debugPrint('Image loading error: $error for URL: $imageUrl');
        }
      },
    );
  }
  
  Widget _buildOptimizedPlaceholder() {
    if (kReleaseMode) {
      // Simple placeholder for better performance
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    } else {
      // Full shimmer effect in debug mode
      return placeholder ?? LoadingShimmer().loadingCircle();
    }
  }
  
  Widget _buildProgressIndicator(ImageChunkEvent downloadProgress) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: downloadProgress.expectedTotalBytes != null
                ? downloadProgress.cumulativeBytesLoaded / downloadProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
            backgroundColor: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

// Optimized version for list items with minimal memory footprint
class ImageAppOptimized extends StatelessWidget {
  const ImageAppOptimized({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low, // Lowest quality for lists
        fadeInDuration: const Duration(milliseconds: 100),
        fadeOutDuration: const Duration(milliseconds: 50),
        cacheManager: cacheManager,
        
        // Aggressive memory optimization
        memCacheWidth: width != null ? (width! * 1.5).round() : 200,
        memCacheHeight: height != null ? (height! * 1.5).round() : 200,
        
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const SizedBox.shrink(),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 24, color: Colors.grey),
        ),
      ),
    );
  }
}
