import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../../models/chapter_data_model.dart';
import 'page_chapter_widget.dart';

class HorizontalStyleWidget extends StatefulWidget {
  const HorizontalStyleWidget({
    super.key,
    required this.chapterData,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
    required this.showControls,
  });
  final ChapterData chapterData;
  final PreloadPageController pageController;
  final ValueNotifier<int> currentPage;
  final ValueNotifier<bool> showControls;
  final int totalPages;

  @override
  State<HorizontalStyleWidget> createState() => _HorizontalStyleWidgetState();
}

class _HorizontalStyleWidgetState extends State<HorizontalStyleWidget> {
  Timer? _hideTimer;
  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        widget.showControls.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = widget.chapterData.baseUrl;
    final hash = widget.chapterData.hash;
    return Column(
      children: [
        Expanded(
          child: PreloadPageView.builder(
            controller: widget.pageController,
            itemCount: widget.totalPages,
            preloadPagesCount: min(5, widget.totalPages - 1),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            onPageChanged: (index) {
              widget.currentPage.value = index;
              _startHideTimer();
            },
            itemBuilder: (context, index) {
              final urlImage =
                  '$baseUrl/data/$hash/${widget.chapterData.data[index]}';
              return PageChapterWidget(urlImage: urlImage);
            },
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: widget.currentPage,
          builder: (context, page, _) => LinearProgressIndicator(
            value: widget.totalPages > 0 ? (page + 1) / widget.totalPages : 0.0,
            backgroundColor: Colors.grey[800],
            color: Colors.blueAccent,
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}
