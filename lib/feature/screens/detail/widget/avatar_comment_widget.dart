import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/widget/loading/shimmer.dart';

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final double width;
  final double height;
  const Avatar({
    super.key,
    required this.avatarUrl,
    this.width = 40,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        width: width,
        height: height,
        fit: BoxFit.cover,
        imageUrl: avatarUrl,
        placeholder: (context, url) => LoadingShimmer().loadingAvatar(),
        errorWidget: (context, url, error) => Icon(
          Icons.image_not_supported,
          color: AppColors.gray700,
        ),
      ),
    );
  }
}
