import 'package:app/feature/utils/image_app.dart';
import 'package:flutter/material.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class ItemListMangaWidget extends StatelessWidget {
  const ItemListMangaWidget({
    super.key,
    required this.coverArt,
    required this.title,
    required this.chapters,
    required this.timeUpdate,
    required this.onTap,
  });
  
  final String coverArt;
  final String title;
  final String chapters;
  final String timeUpdate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.6,
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageApp(
                  imageUrl: coverArt,
                  height: 150,
                  width: 100,
                  fit: BoxFit.cover,
                  errorWidget: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff374151),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'C. $chapters',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff868d98),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      timeUpdate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff868d98),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
