import 'package:app/feature/utils/image_app.dart';
import 'package:flutter/material.dart';

class CoverWidget extends StatelessWidget {
  const CoverWidget({
    super.key,
    required this.coverArt,
  });
  final String coverArt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(4, 4),
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: RepaintBoundary(
          child: ImageApp(
            imageUrl: coverArt,
            width: 150,
            height: 210,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
