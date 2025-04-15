import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BottomsheetListChapter extends StatelessWidget {
  const BottomsheetListChapter({
    super.key,
    required this.chapters,
    required this.currentChapterId,
    required this.onSelected,
  });

  final List<Chapter> chapters;
  final String currentChapterId;
  final Function(String) onSelected;

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
                  controller: scrollController, // Kết nối scroll controller
                  itemCount: chapters.length,
                  itemBuilder: (BuildContext context, int index) {
                    final chapter = chapters[index];
                    final isSelected = chapter.id == currentChapterId;
                    return ListTile(
                      title: Text(
                        'Chap ${chapter.chapter}',
                        style: AppsTextStyle.text14Weight400.copyWith(
                          color: isSelected
                              ? const Color(0xff1d64f1)
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        chapter.title ?? 'N/a',
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
                        onSelected(chapter.id);
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
