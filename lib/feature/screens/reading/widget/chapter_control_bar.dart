import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/screens/reading/widget/bottomsheet_list_chapter.dart';
import 'package:app/feature/utils/chapter_navigation.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class BottomCtrlReadChapterWidget extends StatefulWidget {
  const BottomCtrlReadChapterWidget({
    super.key,
    required this.currentChapter,
    required this.listChapters,
    required this.onChapterChange,
    required this.chapter,
    required this.onLoadMore,
  });
  final String currentChapter;
  final List<ChapterWrapper> listChapters;
  final Function(String) onChapterChange;
  final Function() onLoadMore;
  final String chapter;

  @override
  State<BottomCtrlReadChapterWidget> createState() =>
      _BottomCtrlReadChapterWidgetState();
}

class _BottomCtrlReadChapterWidgetState
    extends State<BottomCtrlReadChapterWidget> {
  final ValueNotifier<String> idCurrentChapter = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    idCurrentChapter.value = widget.currentChapter;
  }

  @override
  void didUpdateWidget(covariant BottomCtrlReadChapterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentChapter != widget.currentChapter) {
      idCurrentChapter.value = widget.currentChapter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xffd1d5db),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ChapterNavButton(
            icon: IconlyLight.arrowLeft2,
            isDisabled: ChapterNavigation.isFirstChapter(
                idCurrentChapter.value, widget.listChapters),
            onTap: () async {
              final newChapterId = await ChapterNavigation.navigateChapter(
                currentChapterId: idCurrentChapter.value,
                chapters: widget.listChapters,
                isNext: true,
                onChapterChange: widget.onChapterChange,
              );
              if (newChapterId != null) {
                idCurrentChapter.value = newChapterId;
              }
            },
          ),
          ValueListenableBuilder(
            valueListenable: idCurrentChapter,
            builder: (context, currentId, _) {
              final chapter = widget.listChapters
                      .firstWhereOrNull((element) => element.id == currentId)
                      ?.attributes
                      .chapter ??
                  '';

              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => BottomsheetListChapter(
                      chapters: widget.listChapters,
                      currentChapterId: idCurrentChapter.value,
                      onSelected: (id) {
                        idCurrentChapter.value = id;
                        widget.onChapterChange(id);
                      },
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xff9ca3af),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      'Chap $chapter',
                      key: ValueKey(chapter),
                      style: AppsTextStyle.text14Weight500
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          ),
          ChapterNavButton(
            icon: IconlyLight.arrowRight2,
            isDisabled: ChapterNavigation.isLastChapter(
                idCurrentChapter.value, widget.listChapters),
            onTap: () async {
              final newChapterId = await ChapterNavigation.navigateChapter(
                currentChapterId: idCurrentChapter.value,
                chapters: widget.listChapters,
                isNext: false,
                onChapterChange: widget.onChapterChange,
              );
              if (newChapterId != null) {
                idCurrentChapter.value = newChapterId;
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChapterNavButton extends StatelessWidget {
  final IconData icon;
  final bool isDisabled;
  final VoidCallback? onTap;

  const ChapterNavButton(
      {super.key, required this.icon, required this.isDisabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey : const Color(0xff1d4ed8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
