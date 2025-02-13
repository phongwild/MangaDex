import 'package:app/core_ui/widget/loading/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class ItemListMangaWidget extends StatefulWidget {
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
  State<ItemListMangaWidget> createState() => _ItemListMangaWidgetState();
}

class _ItemListMangaWidgetState extends State<ItemListMangaWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.6,
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.coverArt,
                fit: BoxFit.cover,
                height: 150,
                width: 100,
                placeholder: (context, url) =>
                    const Center(child: VPBankLoading()),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                    size: 50,
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
                      widget.title,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: AppsTextStyle.text14Weight600
                          .copyWith(color: const Color(0xff374151)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'C. ${widget.chapters}',
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: AppsTextStyle.text14Weight600
                          .copyWith(color: const Color(0xff868d98)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.timeUpdate,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: AppsTextStyle.text14Weight400
                          .copyWith(color: const Color(0xff868d98)),
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
