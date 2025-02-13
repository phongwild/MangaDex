import 'dart:async';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/widget/loading/loading.dart';
import 'package:app/feature/cubit/detail_manga_cubit.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/screens/reading/widget/bottom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadChapterPage extends StatefulWidget {
  const ReadChapterPage({
    super.key,
    required this.idChapter,
    required this.idManga,
    required this.listChapters,
  });
  final String idChapter;
  final String idManga;
  final List<Chapter> listChapters;

  @override
  State<ReadChapterPage> createState() => _ReadChapterPageState();
}

class _ReadChapterPageState extends State<ReadChapterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailMangaCubit(),
      child: _BodyPage(
        idChapter: widget.idChapter,
        idManga: widget.idManga,
        listChapters: widget.listChapters,
      ),
    );
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage({
    required this.idChapter,
    required this.idManga,
    required this.listChapters,
  });
  final String idChapter;
  final String idManga;
  final List<Chapter> listChapters;

  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  final PageController _pageController = PageController(viewportFraction: 0.95);
  final ValueNotifier<int> currentPage = ValueNotifier(0);
  final ValueNotifier<bool> _showControls = ValueNotifier(true);
  Timer? _hideTimer;

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
    context.read<DetailMangaCubit>().getReadChapter(widget.idChapter);
    _startHideTimer();
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
                builder: (context, state) {
                  if (state is DetailMangaStateError) {
                    return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }
                  if (state is DetailMangaStateLoading) {
                    return const Center(child: VPBankLoading());
                  }
                  if (state is ChapterStateLoaded) {
                    final chapterData = state.chapterData;
                    return Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: chapterData.data.length,
                            onPageChanged: (index) {
                              currentPage.value = index;
                              _startHideTimer();
                            },
                            itemBuilder: (context, index) {
                              final baseUrl = chapterData.baseUrl;
                              final String listPage = chapterData.data[index];
                              final urlImage =
                                  '$baseUrl/data/${chapterData.hash}/$listPage';
                              return CachedNetworkImage(
                                imageUrl: urlImage,
                                fit: BoxFit.contain,
                                fadeInDuration:
                                    const Duration(milliseconds: 300),
                                placeholder: (context, url) =>
                                    const Center(child: VPBankLoading()),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.white, size: 50),
                                ),
                              );
                            },
                          ),
                        )
                      ],
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
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        BottomCtrlReadChapterWidget(
                          currentChapter: widget.idChapter,
                          listChapters: widget.listChapters,
                        )
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
}
