import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoverWidget extends StatefulWidget {
  const CoverWidget({
    super.key,
    required this.coverArt,
  });
  final String coverArt;

  @override
  State<CoverWidget> createState() => _CoverWidgetState();
}

class _CoverWidgetState extends State<CoverWidget> {
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
        child: CachedNetworkImage(
          imageUrl: widget.coverArt,
          fadeInDuration: const Duration(milliseconds: 300),
          fit: BoxFit.cover,
          height: 210,
          width: 150,
        ),
      ),
    );
  }
}
