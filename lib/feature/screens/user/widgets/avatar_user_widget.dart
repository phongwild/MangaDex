import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class AvatarUserWidget extends StatelessWidget {
  const AvatarUserWidget({super.key, this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: (imageUrl != null && imageUrl!.isNotEmpty) // Kiểm tra null trước
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => LoadingShimmer().loadingAvatar(),
                errorWidget: (context, url, error) =>
                    LoadingShimmer().loadingAvatar(),
              )
            : LoadingShimmer()
                .loadingAvatar(), // Nếu không có ảnh, hiển thị shimmer
      ),
    );
  }
}
