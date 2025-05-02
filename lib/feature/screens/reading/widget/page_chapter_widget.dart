import 'package:app/feature/utils/image_app.dart';
import 'package:flutter/material.dart';

class PageChapterWidget extends StatelessWidget {
  const PageChapterWidget({
    super.key,
    required this.urlImage,
    this.isZoom = false,
  });

  final String urlImage;
  final bool isZoom;

  @override
  Widget build(BuildContext context) {
    final image = RepaintBoundary(
      child: ImageApp(
        imageUrl: urlImage,
        width: double.infinity,
        errorWidget: const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.white),
        ),
      ),
    );

    if (!isZoom) return image;

    final controller = TransformationController();

    return ClipRect(
      child: GestureDetector(
        onDoubleTap: () => controller.value = Matrix4.identity(),
        child: InteractiveViewer(
          transformationController: controller,
          panEnabled: false,
          scaleEnabled: true,
          minScale: 1.0,
          maxScale: 3.0,
          clipBehavior: Clip.none,
          child: image,
        ),
      ),
    );
  }
}
