import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LargeCoverWidget extends StatelessWidget {
  const LargeCoverWidget({
    super.key,
    required this.coverArt,
  });
  final String coverArt;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: coverArt,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.white54,
          size: 50,
        ),
      ),
    );
  }
}
