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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = widget.chapterData.baseUrl;
    final hash = widget.chapterData.hash;
    final String chapter = widget.listChapters
            .firstWhereOrNull((element) => element.id == widget.idChapter)
            ?.attributes
            .chapter ??
        '';
    final String title = widget.listChapters
            .firstWhereOrNull((element) => element.id == widget.idChapter)
            ?.attributes
            .title ??
        '';
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

              if (index == 0) {
                return SE('Chương $chapter: $title');
              }
              if (index == widget.totalPages - 1) {
                return SE('Kết thúc chương $chapter');
              }
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
            duration: const Duration(milliseconds: 100),
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
