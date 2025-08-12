// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../../../models/chapter_data_model.dart';
import 'page_chapter_widget.dart';

class VerticalWidget extends StatelessWidget {
  const VerticalWidget({
    super.key,
    required this.totalPages,
    required this.chapterData,
  });

  final int totalPages;
  final ChapterData chapterData;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      radius: const Radius.circular(10),
      thickness: 6,
      child: ListView.separated(
        itemCount: totalPages,
        physics: const ClampingScrollPhysics(),
        cacheExtent: MediaQuery.of(context).size.height * 2,
        separatorBuilder: (context, index) => const SizedBox(height: 5),
        addAutomaticKeepAlives: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final baseUrl = chapterData.baseUrl;
          final String listPage = chapterData.data[index];
          final urlImage = '$baseUrl/data/${chapterData.hash}/$listPage';
          // Cache image for better performance
          return PageChapterWidget(
            urlImage: urlImage,
            isZoom: false,
          );
        },
      ),
    );
  }
}
