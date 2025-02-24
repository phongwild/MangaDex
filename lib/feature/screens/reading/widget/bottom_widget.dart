import 'package:app/feature/models/chapter_model.dart';
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
  });
  final String currentChapter;
  final List<Chapter> listChapters;
  final Function(String) onChapterChange;
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

  void nextChapter(bool isNext) {
    int currentIndex = widget.listChapters
        .indexWhere((element) => element.id == idCurrentChapter.value);
    if (currentIndex == -1) return;

    final nextIndex = isNext ? currentIndex + 1 : currentIndex - 1;
    if (nextIndex >= 0 && nextIndex < widget.listChapters.length) {
      final nextChapter = widget.listChapters[nextIndex];
      idCurrentChapter.value = nextChapter.id;
      widget.onChapterChange(nextChapter.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
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
                nextChapter(true);
              },
              child: buildButton(IconlyLight.arrowLeft2),
            ),
            ValueListenableBuilder(
              valueListenable: idCurrentChapter,
              builder: (context, currentId, _) {
                final chapter = widget.listChapters
                    .firstWhere((element) => element.id == currentId)
                    .chapter;
                return GestureDetector(
                  onTap: () => widget.onChapterChange(currentId),
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
                nextChapter(false);
              },
              child: buildButton(IconlyLight.arrowRight2),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xff1d4ed8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
