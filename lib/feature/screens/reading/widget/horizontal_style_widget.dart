import 'dart:async';
import 'dart:math';

import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/design_system/app_button.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/utils/chapter_navigation.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../../models/chapter_data_model.dart';
import 'page_chapter_widget.dart';

class HorizontalStyleWidget extends StatefulWidget {
  HorizontalStyleWidget({
    super.key,
    required this.chapterData,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
    required this.showControls,
    required this.listChapters,
    required this.idChapter,
    required this.onChapterChange,
  });
  final ChapterData chapterData;
  String idChapter;
  final PreloadPageController pageController;
  final List<ChapterWrapper> listChapters;
  final ValueNotifier<int> currentPage;
  final ValueNotifier<bool> showControls;
  final int totalPages;
  final Function(String) onChapterChange;

  @override
  State<HorizontalStyleWidget> createState() => _HorizontalStyleWidgetState();
}

class _HorizontalStyleWidgetState extends State<HorizontalStyleWidget> {
  Timer? _hideTimer;
  Timer? _debounceTimer;
  void _startHideTimer() {
    _hideTimer?.cancel();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          widget.showControls.value = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = widget.chapterData.baseUrl;
    final hash = widget.chapterData.hash;
    final List<String> pages = widget.chapterData.data;
    final chapterData =
        widget.listChapters.firstWhereOrNull((e) => e.id == widget.idChapter);

    final String chapter = chapterData?.attributes.chapter ?? '';
    final String title = chapterData?.attributes.title ?? '';
    return Column(
      children: [
        Expanded(
          child: PreloadPageView.builder(
            controller: widget.pageController,
            itemCount: widget.totalPages,
            preloadPagesCount:
                widget.totalPages <= 1 ? 0 : min(3, widget.totalPages - 1),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            onPageChanged: (index) {
              widget.currentPage.value = index;
              _startHideTimer();
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return SE('Chương $chapter: $title');
              }
              if (index == widget.totalPages - 1) {
                return SE('Kết thúc chương $chapter');
              }
              final urlImage = '$baseUrl/data/$hash/${pages[index]}';
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
          builder: (context, page, _) {
            final progress =
                widget.totalPages <= 0 ? 0.0 : (page + 1) / widget.totalPages;

            return LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[800],
              color: Colors.blueAccent,
              minHeight: 5,
            );
          },
        ),
      ],
    );
  }

  Container SE(String title) {
    bool isLastChapter =
        ChapterNavigation.isLastChapter(widget.idChapter, widget.listChapters);
    bool isFirstChapter =
        ChapterNavigation.isFirstChapter(widget.idChapter, widget.listChapters);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                AppsTextStyle.text14Weight500.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 30),
          AppButton(
            onPressed: () async {
              isLastChapter
                  ? showToast('Đây là chương cuối gòi!!!!', isError: true)
                  : await ChapterNavigation.navigateChapter(
                      currentChapterId: widget.idChapter,
                      chapters: widget.listChapters,
                      isNext: false,
                      onChapterChange: widget.onChapterChange,
                    );
            },
            action: 'Chương sau',
            textStyle:
                AppsTextStyle.text14Weight400.copyWith(color: AppColors.white),
            colorEnable: isLastChapter ? AppColors.gray700 : AppColors.blue,
          ),
          AppButton(
            onPressed: () async {
              isFirstChapter
                  ? showToast('Đây là chương đầu nha', isError: true)
                  : await ChapterNavigation.navigateChapter(
                      currentChapterId: widget.idChapter,
                      chapters: widget.listChapters,
                      isNext: true,
                      onChapterChange: widget.onChapterChange,
                    );
            },
            action: 'Chương trước',
            textStyle:
                AppsTextStyle.text14Weight400.copyWith(color: AppColors.white),
            colorEnable: isFirstChapter ? AppColors.gray700 : AppColors.blue,
            overlayColor: false,
          ),
        ],
      ),
    );
  }
}
