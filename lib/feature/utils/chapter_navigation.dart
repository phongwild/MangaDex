import 'package:app/feature/models/chapter_model.dart';
import 'package:flutter/material.dart';

class ChapterNavigation {
  static Future<String?> navigateChapter({
    required String currentChapterId,
    required List<ChapterWrapper> chapters,
    required bool isNext,
    required ValueChanged<String> onChapterChange,
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) async {
    // Ngăn spam navigation
    bool isNavigating = false;
    if (isNavigating) return null;
    isNavigating = true;

    // Tìm index của chapter hiện tại
    final currentIndex = chapters.indexWhere((e) => e.id == currentChapterId);
    if (currentIndex == -1) {
      isNavigating = false;
      return null; // Chapter không tìm thấy
    }

    // Tính index chapter tiếp theo
    final nextIndex = isNext ? currentIndex + 1 : currentIndex - 1;

    // Kiểm tra giới hạn
    if (nextIndex < 0 || nextIndex >= chapters.length) {
      isNavigating = false;
      return null; // Vượt giới hạn
    }

    // Lấy ID chapter mới
    final nextChapterId = chapters[nextIndex].id;
    onChapterChange(nextChapterId);

    // Debounce để ngăn spam
    await Future.delayed(debounceDuration);
    isNavigating = false;

    return nextChapterId;
  }

  /// Kiểm tra xem chapter hiện tại có phải là chapter đầu tiên không
  static bool isFirstChapter(
      String currentChapterId, List<ChapterWrapper> chapters) {
    final currentIndex = chapters.indexWhere((e) => e.id == currentChapterId);
    return currentIndex >= chapters.length - 1;
  }

  /// Kiểm tra xem chapter hiện tại có phải là chapter cuối cùng không
  static bool isLastChapter(
      String currentChapterId, List<ChapterWrapper> chapters) {
    final currentIndex = chapters.indexWhere((e) => e.id == currentChapterId);
    return currentIndex <= 0;
  }
}
