import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core_ui/widget/loading/loading.dart';

class PageChapterWidget extends StatefulWidget {
  const PageChapterWidget({
    super.key,
    required this.urlImage,
  });

  final String urlImage;

  @override
  State<PageChapterWidget> createState() => _PageChapterWidgetState();
}

class _PageChapterWidgetState extends State<PageChapterWidget> {
  final TransformationController _transformationController =
      TransformationController();

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _resetZoom,
      child: InteractiveViewer(
        transformationController: _transformationController,
        panEnabled: false,
        scaleEnabled: true,
        minScale: 1.0,
        maxScale: 3.0,
        clipBehavior: Clip.none,
        child: CachedNetworkImage(
          imageUrl: widget.urlImage,
          fit: BoxFit.contain,
          width: double.infinity,
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: (context, url) => const Center(child: VPBankLoading()),
          errorWidget: (context, url, error) => const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
