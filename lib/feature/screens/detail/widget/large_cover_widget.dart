import 'package:app/feature/utils/image_app.dart';
import 'package:flutter/material.dart';

class LargeCoverWidget extends StatelessWidget {
  const LargeCoverWidget({
    super.key,
    required this.coverArt,
  });
  final String coverArt;
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ImageApp(
        imageUrl: coverArt,
        fit: BoxFit.cover,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        errorWidget: const Center(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.white54,
            size: 50,
          ),
        ),
      ),
    );
  }
}
