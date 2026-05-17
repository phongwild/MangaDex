import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/design_system/app_button.dart';
import 'package:app/feature/utils/chapter_navigation.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../models/chapter_data_model.dart';
import '../../../models/chapter_model.dart';
import 'page_chapter_widget.dart';

class VerticalWidget extends StatefulWidget {
  VerticalWidget({
    super.key,
    required this.chapterData,
    required this.listChapters,
    required this.idChapter,
    required this.onChapterChange,
    required this.totalPages,
  });

  final ChapterData chapterData;
  String idChapter;
  final int totalPages;
  final List<ChapterWrapper> listChapters;
  final Function(String) onChapterChange;
  @override
  State<VerticalWidget> createState() => _VerticalWidgetState();
}

class _VerticalWidgetState extends State<VerticalWidget> {
  @override
  Widget build(BuildContext context) {
    final baseUrl = widget.chapterData.baseUrl;
    final hash = widget.chapterData.hash;
    final chapterData =
        widget.listChapters.firstWhereOrNull((e) => e.id == widget.idChapter);
    final List<String> pages = widget.chapterData.data;
    final String chapter = chapterData?.attributes.chapter ?? '';
    final String title = chapterData?.attributes.title ?? '';
    return Scrollbar(
      thumbVisibility: true,
      radius: const Radius.circular(10),
      thickness: 6,
      child: ListView.builder(
        itemCount: widget.totalPages,
        physics: const ClampingScrollPhysics(),
        cacheExtent: MediaQuery.of(context).size.height,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SE('Chương $chapter: $title');
          }
          if (index == widget.totalPages - 1) {
            return SE('Kết thúc chương $chapter');
          }
          final urlImage = '$baseUrl/data/$hash/${pages[index]}';
          return RepaintBoundary(
            child: PageChapterWidget(
              urlImage: urlImage,
              isZoom: false,
            ),
          );
        },
      ),
    );
  }

  Container SE(String title) {
    bool isLastChapter =
        ChapterNavigation.isLastChapter(widget.idChapter, widget.listChapters);
    bool isFirstChapter =
        ChapterNavigation.isFirstChapter(widget.idChapter, widget.listChapters);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style:
                AppsTextStyle.text14Weight500.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 10),
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
