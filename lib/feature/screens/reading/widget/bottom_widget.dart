import 'package:app/feature/cubit/detail_manga_cubit.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class BottomCtrlReadChapterWidget extends StatefulWidget {
  const BottomCtrlReadChapterWidget({
    super.key,
    required this.currentChapter,
    required this.listChapters,
    this.onTap,
  });
  final String currentChapter;
  final List<Chapter> listChapters;
  final VoidCallback? onTap;
  @override
  State<BottomCtrlReadChapterWidget> createState() =>
      _BottomCtrlReadChapterWidgetState();
}

class _BottomCtrlReadChapterWidgetState
    extends State<BottomCtrlReadChapterWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailMangaCubit, DetailMangaState>(
      builder: (context, state) {
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
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff1d4ed8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      IconlyLight.arrowLeft2,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xff9ca3af),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Chap 1',
                      style: AppsTextStyle.text14Weight500
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff1d4ed8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      IconlyLight.arrowRight2,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
