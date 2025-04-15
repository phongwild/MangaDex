// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';

import '../../../models/chapter_data_model.dart';
import 'page_chapter_widget.dart';

class vertical_widget extends StatelessWidget {
  const vertical_widget({
    super.key,
    required this.totalPages,
    required this.chapterData,
  });

  final int totalPages;
  final ChapterData chapterData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: totalPages,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      cacheExtent: 2000,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final baseUrl = chapterData.baseUrl;
        final String listPage = chapterData.data[index];
        final urlImage = '$baseUrl/data/${chapterData.hash}/$listPage';
        // Cache image for better performance
        return PageChapterWidget(urlImage: urlImage);
      },
    );
  }
}
