import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BottomsheetListChapter extends StatefulWidget {
  const BottomsheetListChapter({
    super.key,
    required this.chapters,
    required this.currentChapterId,
    required this.onSelected,
  });
  final List<ChapterWrapper> chapters;
  final String currentChapterId;
  final Function(String) onSelected;
  @override
  State<BottomsheetListChapter> createState() => _BottomsheetListChapterState();
}

class _BottomsheetListChapterState extends State<BottomsheetListChapter> {
  bool _didScrollToCurrent = false;
  void _scrollToCurrentChapter(
    ScrollController controller,
  ) {
    if (_didScrollToCurrent) return;
    final index = widget.chapters.indexWhere(
      (e) => e.id == widget.currentChapterId,
    );
    if (index == -1) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        const Duration(milliseconds: 100),
      );
      if (!mounted || !controller.hasClients) return;
      final position = index * 72.0;
      final maxScroll = controller.position.maxScrollExtent;
      controller.jumpTo(
        position.clamp(0, maxScroll),
      );
      _didScrollToCurrent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        _scrollToCurrentChapter(scrollController);
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffd1d5db),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: widget.chapters.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final chapter = widget.chapters[index];
                    final isSelected = chapter.id == widget.currentChapterId;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        'Chap ${chapter.attributes.chapter}',
                        style: AppsTextStyle.text14Weight400.copyWith(
                          color: isSelected
                              ? const Color(0xff1d64f1)
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        chapter.attributes.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppsTextStyle.text14Weight400.copyWith(
                          color: isSelected
                              ? const Color(0xff1d64f1)
                              : Colors.black54,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              IconlyLight.arrowLeft,
                              size: 14,
                              color: Color(0xff1d64f1),
                            )
                          : null,
                      onTap: () {
                        widget.onSelected(chapter.id);
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
