import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LargeCoverWidget extends StatefulWidget {
  const LargeCoverWidget({
    super.key, required this.coverArt,
  });
  final String coverArt;
  @override
  State<LargeCoverWidget> createState() => _LargeCoverWidgetState();
}

class _LargeCoverWidgetState extends State<LargeCoverWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: CachedNetworkImage(
        imageUrl: widget.coverArt,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        fit: BoxFit.cover,
      ),
    );
  }
}
