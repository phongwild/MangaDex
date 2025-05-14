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
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: PageChapterWidget(
                  urlImage: urlImage,
                  isZoom: true,
                ),
              );
            },
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: widget.currentPage,
          builder: (context, page, _) => TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: (page) / widget.totalPages,
              end: (page + 1) / widget.totalPages,
            ),
            duration: const Duration(milliseconds: 200),
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[800],
              color: Colors.blueAccent,
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }
}
