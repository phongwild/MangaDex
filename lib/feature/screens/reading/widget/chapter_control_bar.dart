import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/screens/reading/widget/bottomsheet_list_chapter.dart';
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
  final ValueNotifier<bool> isLimit = ValueNotifier(false);
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

  void nextChapter(bool isNext) {
    int currentIndex =
        widget.listChapters.indexWhere((e) => e.id == idCurrentChapter.value);
    if (currentIndex == -1) return;

    final nextIndex = isNext ? currentIndex + 1 : currentIndex - 1;

    // Kiểm tra giới hạn trước khi thay đổi
    if (nextIndex < 0 || nextIndex >= widget.listChapters.length) return;

    final nextChapter = widget.listChapters[nextIndex];
    idCurrentChapter.value = nextChapter.id;
    widget.onChapterChange(nextChapter.id);
  }

  bool isFirstChapter() {
    int currentIndex =
        widget.listChapters.indexWhere((e) => e.id == idCurrentChapter.value);
    return currentIndex >= widget.listChapters.length - 1;
  }

  bool isLastChapter() {
    int currentIndex =
        widget.listChapters.indexWhere((e) => e.id == idCurrentChapter.value);
    return currentIndex <= 0;
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
          GestureDetector(
            onTap: () {
              isFirstChapter() ? null : nextChapter(true);
            },
            child: buildButton(IconlyLight.arrowLeft2, isFirstChapter()),
          ),
          ValueListenableBuilder(
            valueListenable: idCurrentChapter,
            builder: (context, currentId, _) {
              final chapter = widget.listChapters
                  .firstWhere((element) => element.id == currentId)
                  .attributes
                  .chapter;
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
                  child: Text(
                    'Chap $chapter',
                    style: AppsTextStyle.text14Weight500
                        .copyWith(color: Colors.black),
                  ),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              isLastChapter() ? null : nextChapter(false);
            },
            child: buildButton(IconlyLight.arrowRight2, isLastChapter()),
          )
        ],
      ),
    );
  }

  Widget buildButton(IconData icon, bool isLimit) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: !isLimit ? const Color(0xff1d4ed8) : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
