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
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index =
          widget.chapters.indexWhere((e) => e.id == widget.currentChapterId);
      if (index != -1) {
        _scrollController.jumpTo(
          index * 72.0, // điều chỉnh lại nếu chiều cao item khác nha
          // duration: const Duration(milliseconds: 300),
          // curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6, // chiếm 60% màn hình lúc mở
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffd1d5db),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  controller: _scrollController, // Kết nối scroll controller
                  itemCount: widget.chapters.length,
                  itemBuilder: (BuildContext context, int index) {
                    final chapter = widget.chapters[index];
                    final isSelected = chapter.id == widget.currentChapterId;
                    return ListTile(
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
                        style: AppsTextStyle.text14Weight400.copyWith(
                          color: isSelected
                              ? const Color(0xff1d64f1)
                              : Colors.black,
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
                        Navigator.pop(context); // Đóng BottomSheet khi chọn
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
