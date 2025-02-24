import 'package:flutter/cupertino.dart';

import 'cover_widget.dart';
import 'large_cover_widget.dart';

class CoverDetailWidget extends StatelessWidget {
  const CoverDetailWidget({
    super.key,
    required this.coverArt,
  });

  final String coverArt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: Stack(
        children: [
          LargeCoverWidget(coverArt: coverArt),
          Align(
            alignment: Alignment.bottomCenter,
            child: CoverWidget(
              coverArt: coverArt,
            ),
          ),
        ],
      ),
    );
  }
}
