import 'dart:async';
import 'dart:math';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/cubit/detail_manga_cubit.dart';
import 'package:app/feature/models/chapter_data_model.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/screens/reading/widget/chapter_control_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'widget/page_chapter_widget.dart';
import 'widget/vertical_style_widget.dart';

class ReadChapterPage extends StatefulWidget {
  const ReadChapterPage({
    super.key,
    required this.idChapter,
    required this.idManga,
    required this.listChapters,
    this.chapter,
  });
  final String idChapter;
  final String idManga;
  final List<Chapter> listChapters;
  final String? chapter;

  @override
  State<ReadChapterPage> createState() => _ReadChapterPageState();
}

class _ReadChapterPageState extends State<ReadChapterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailMangaCubit()..getReadChapter(widget.idChapter),
      child: _BodyPage(
        idChapter: widget.idChapter,
        idManga: widget.idManga,
        listChapters: widget.listChapters,
        chapter: widget.chapter,
      ),
    );
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage({
    required this.idChapter,
    required this.idManga,
    required this.listChapters,
    this.chapter,
  });
  final String idChapter;
  final String idManga;
  final List<Chapter> listChapters;
  final String? chapter;

  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  final PreloadPageController _pageController = PreloadPageController();
  final ValueNotifier<int> currentPage = ValueNotifier(0);
  final ValueNotifier<bool> _showControls = ValueNotifier(true);
  final ValueNotifier<bool> styleReading = ValueNotifier(false);
  final ValueNotifier<String> idCurrentChapter = ValueNotifier('');

  Timer? _hideTimer;
  int totalPages = 1;

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _showControls.value = false;
      }
    });
  }

  void _toggleControls() {
    _showControls.value = !_showControls.value;
    if (_showControls.value) _startHideTimer();
  }

  @override
  void initState() {
    super.initState();
    idCurrentChapter.value = widget.idChapter;
    _startHideTimer();
  }

  void updateChapter(String newId) {
    if (idCurrentChapter.value != newId) {
      idCurrentChapter.value = newId;
      context.read<DetailMangaCubit>().getReadChapter(newId);
      _pageController.jumpToPage(0);
      currentPage.value = 0;
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111827),
      body: SafeArea(
        child: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              BlocBuilder<DetailMangaCubit, DetailMangaState>(
                buildWhen: (previous, current) {
                  return current is ChapterStateLoaded;
                },
                builder: (context, state) {
                  if (state is DetailMangaStateError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  if (state is DetailMangaStateLoading) {
                    return Center(child: LoadingShimmer().loadingCircle());
                  }
                  if (state is ChapterStateLoaded) {
                    final chapterData = state.chapterData;
                    totalPages = chapterData.data.length;
                    preloadImages(chapterData.data, chapterData);
                    return ValueListenableBuilder<bool>(
                      valueListenable: styleReading,
                      builder: (context, value, child) {
                        // Kiểm tra xem kiểu đọc có phải là ngang hay dọc
                        if (styleReading.value == false) {
                          return styleHorizontal(chapterData);
                        } else {
                          return vertical_widget(
                            totalPages: totalPages,
                            chapterData: chapterData,
                          );
                        }
                      },
                    );
                  }
                  return Center(
                    child: Text(
                      'Lỗi, hãy thử lại sau!',
                      style: AppsTextStyle.text14Weight500.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _showControls,
                builder: (context, showControls, child) {
                  return Visibility(
                    visible: showControls,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: styleReading,
                          builder: (context, value, child) {
                            return Positioned(
                              top: 15,
                              left: 100,
                              right: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            styleReading.value =
                                                !styleReading.value;
                                          },
                                          child: Container(
                                            color: styleReading.value
                                                ? const Color(0xff2563eb)
                                                : const Color(0xff18212f),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Classic UI',
                                              style: AppsTextStyle
                                                  .text14Weight600
                                                  .copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            styleReading.value =
                                                !styleReading.value;
                                          },
                                          child: Container(
                                            color: styleReading.value
                                                ? const Color(0xff18212f)
                                                : const Color(0xff2563eb),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Zen UI',
                                              style: AppsTextStyle
                                                  .text14Weight600
                                                  .copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        BottomCtrlReadChapterWidget(
                          currentChapter: idCurrentChapter.value,
                          listChapters: widget.listChapters,
                          chapter: widget.chapter ?? '',
                          onChapterChange: (newId) {
                            updateChapter(newId);
                          },
                          onLoadMore: () {
                            context.read<DetailMangaCubit>().getDetailManga(
                                  widget.idManga,
                                  true,
                                  offset: 1,
                                );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void preloadImages(List<String> imageUrls, ChapterData chapterData) {
    for (var url in imageUrls) {
      final imageUrl = '${chapterData.baseUrl}/data/${chapterData.hash}/$url';
      precacheImage(CachedNetworkImageProvider(imageUrl), context);
    }
  }

  Widget styleHorizontal(ChapterData chapterData) {
    final baseUrl = chapterData.baseUrl;
    final hash = chapterData.hash;
    return Column(
      children: [
        Expanded(
          child: PreloadPageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            preloadPagesCount: min(5, totalPages - 1),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            onPageChanged: (index) {
              if (index + 1 < totalPages) {
                // final image = NetworkImage(chapterData.data[index]);
                // precacheImage(image, context);
                currentPage.value = index;
                _startHideTimer();
              }
            },
            itemBuilder: (context, index) {
              final urlImage = '$baseUrl/data/$hash/${chapterData.data[index]}';
              return PageChapterWidget(urlImage: urlImage);
            },
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: currentPage,
          builder: (context, page, _) => LinearProgressIndicator(
            value: (page + 1) / totalPages,
            backgroundColor: Colors.grey[800],
            color: Colors.blueAccent,
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}
