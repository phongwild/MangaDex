import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/chapter_data_model.dart';
import 'page_chapter_widget.dart';

class VerticalWidget extends StatefulWidget {
  const VerticalWidget({
    super.key,
    required this.totalPages,
    required this.chapterData,
  });

  final int totalPages;
  final ChapterData chapterData;

  @override
  State<VerticalWidget> createState() => _VerticalWidgetState();
}

class _VerticalWidgetState extends State<VerticalWidget> {
  late final List<String> _imageUrls;

  @override
  void initState() {
    super.initState();

    final baseUrl = widget.chapterData.baseUrl;
    final hash = widget.chapterData.hash;

    // cache URL 1 lần thôi, khỏi build lại mỗi item
    _imageUrls =
        widget.chapterData.data.map((e) => '$baseUrl/data/$hash/$e').toList();

    // precache 2-3 ảnh đầu cho mượt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < math.min(3, _imageUrls.length); i++) {
        precacheImage(NetworkImage(_imageUrls[i]), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      radius: const Radius.circular(10),
      thickness: 6,
      child: ListView.builder(
        itemCount: _imageUrls.length,
        physics: const ClampingScrollPhysics(),
        cacheExtent: MediaQuery.of(context).size.height,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            child: PageChapterWidget(
              urlImage: _imageUrls[index],
              isZoom: false,
            ),
          );
        },
      ),
    );
  }
}
