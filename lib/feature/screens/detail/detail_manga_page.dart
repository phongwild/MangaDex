// ignore_for_file: unnecessary_null_comparison

import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/widget/loading/loading.dart';
import 'package:app/feature/cubit/detail_manga_cubit.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/models/tag_model.dart';
import 'package:app/feature/screens/detail/widget/large_cover_widget.dart';
import 'package:app/feature/screens/detail/widget/list_chapter_widget.dart';
import 'package:app/feature/screens/detail/widget/tag_widget.dart';
import 'package:app/feature/screens/reading/read_chapter_page.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../widgets/button_app_widget.dart';
import 'widget/cover_widget.dart';
import 'widget/description_widget.dart';

class DetailMangaPage extends StatefulWidget {
  const DetailMangaPage(
      {super.key,
      required this.idManga,
      required this.coverArt,
      required this.lastUpdate,
      required this.title});
  final String idManga;
  final String title;
  final String coverArt;
  final String lastUpdate;
  @override
  State<DetailMangaPage> createState() => _DetailMangaPageState();
}

class _DetailMangaPageState extends State<DetailMangaPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailMangaCubit()
        ..getDetailManga(
          widget.idManga,
          true,
        ),
      child: _BodyPage(
        idManga: widget.idManga,
        coverArt: widget.coverArt,
        lastUpdate: widget.lastUpdate,
        title: widget.title,
      ),
    );
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage({
    required this.idManga,
    required this.coverArt,
    required this.lastUpdate,
    required this.title,
  });
  final String idManga;
  final String coverArt;
  final String lastUpdate;
  final String title;
  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentPage = ValueNotifier(1);
    return Scaffold(
      backgroundColor: const Color(0xffe5e7eb),
      appBar: AppBar(
        backgroundColor: const Color(0xffe5e7eb),
        elevation: 0,
        toolbarHeight: 40,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 10,
          ),
          child: SingleChildScrollView(
            child: BlocBuilder<DetailMangaCubit, DetailMangaState>(
              builder: (context, state) {
                if (state is DetailMangaStateLoading) {
                  return const Center(
                    child: VPBankLoading(),
                  );
                }
                if (state is DetailMangaStateError) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is DetailMangaStateLoaded) {
                  final data = state.manga;
                  final List<Chapter> chapters = state.chapters;
                  final List<Tag> tag = data.attributes.tags;
                  final description = data.attributes.description;
                  final String firstChapter = chapters.last.id;
                  final int total = state.total;
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(4, 4),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    coverManga(),
                                    const SizedBox(height: 15),
                                    Text(
                                      widget.title,
                                      style: AppsTextStyle.text18Weight700,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      (data.attributes.altTitles != null &&
                                              data.attributes.altTitles
                                                  .isNotEmpty)
                                          ? data.attributes.altTitles[0]
                                          : 'N/a',
                                      style: AppsTextStyle.text14Weight400,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(IconlyLight.timeCircle),
                                        const SizedBox(width: 5),
                                        Text(
                                          timeAgo(state
                                                  .manga.attributes.updatedAt ??
                                              ''),
                                          style: AppsTextStyle.text12Weight400,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    TagWidget(
                                      listTag: tag,
                                      isEnable: false,
                                      onTap: (id) {},
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ButtonAppWidget(
                                        text: 'Theo dõi truyện',
                                        color: const Color(0xff2563eb),
                                        textColor: Colors.white,
                                        isBoxShadow: false,
                                        onTap: () {},
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ButtonAppWidget(
                                        text: 'Đọc từ chap 1',
                                        color: const Color(0xffd1d5db),
                                        isBoxShadow: false,
                                        textColor: Colors.black,
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/read-chapter',
                                              arguments: ReadChapterPage(
                                                idChapter: firstChapter,
                                                idManga: widget.idManga,
                                                listChapters: chapters,
                                              ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DescriptionWidget(
                        desc: description,
                      ),
                      const SizedBox(height: 10),
                      ListChapterWidget(
                        key: ValueKey(chapters.length),
                        listChapters: chapters,
                        idManga: widget.idManga,
                        total: total,
                        currentPage: currentPage,
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget coverManga() {
    return SizedBox(
      height: 390,
      child: Stack(
        children: [
          LargeCoverWidget(coverArt: widget.coverArt),
          Align(
            alignment: Alignment.bottomCenter,
            child: CoverWidget(
              coverArt: widget.coverArt,
            ),
          ),
        ],
      ),
    );
  }
}
