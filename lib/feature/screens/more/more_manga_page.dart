// ignore_for_file: non_constant_identifier_names
import 'dart:math';

import 'package:app/core/app_log.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/cubit/tag_cubit.dart';
import 'package:app/feature/widgets/bottom_sheet_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'widget/item_offset_widget.dart';
import 'widget/list_more_manga_widget.dart';

class MoreMangaPage extends StatefulWidget {
  const MoreMangaPage({super.key, this.tag});
  final String? tag;
  @override
  State<MoreMangaPage> createState() => _MoreMangaPageState();
}

class _MoreMangaPageState extends State<MoreMangaPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MangaCubit()
            ..searchManga('',
                tags: (widget.tag?.isNotEmpty ?? false) ? [widget.tag!] : []),
        ),
        BlocProvider(
          create: (context) => TagCubit()..getTag(),
        ),
      ],
      child: _BodyPage(widget.tag),
    );
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage(this.tag);
  final String? tag;
  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  final ValueNotifier<int> totals = ValueNotifier(0);
  final ValueNotifier<int> currentPage = ValueNotifier(1);
  final int limit = 10;
  List<String> selectedTags = [];

  void filterManga(List<String> tags) {
    dlog('Tag selected: $tags');
    selectedTags = tags;
    currentPage.value = 1;
    context.read<MangaCubit>().searchManga('', tags: tags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1d5db),
      appBar: AppBar(
        backgroundColor: const Color(0xffd1d5db),
        elevation: 0,
        toolbarHeight: 30,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showBottomSheet(context);
            },
            icon: const Icon(IconlyLight.filter, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  ListMoreMangaWidget(totals: totals),
                ],
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: BlocBuilder<MangaCubit, MangaState>(
                  builder: (context, state) {
                    if (state is MangaLoaded) {
                      totals.value = state.total ?? 0;
                      return ListPage(totals.value);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ListPage(int totals) {
    final int totalPages = max(1, (totals / limit).ceil());
    if (totalPages <= 1) return const SizedBox();

    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (context, page, child) {
        List<Widget> items = [];

        items.add(
          ItemOffsetWidget(
              text: '1', isActive: page == 1, onTap: () => changePage(1)),
        );
        if (totalPages <= 3) {
          for (var i = 2; i < totalPages; i++) {
            items.add(
              ItemOffsetWidget(
                text: '$i',
                isActive: page == i,
                onTap: () => changePage(i),
              ),
            );
          }
        } else {
          if (page > 3) {
            items.add(const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('...', style: TextStyle(fontSize: 18)),
            ));
          }

          int start = (page - 1).clamp(2, totalPages - 3);
          int end = (page + 1).clamp(4, totalPages - 1);

          dlog("Tạo danh sách trang từ $start đến $end"); // Debug

          for (int i = start; i <= end; i++) {
            items.add(ItemOffsetWidget(
                text: '$i', isActive: page == i, onTap: () => changePage(i)));
          }

          if (page < totalPages - 2) {
            items.add(const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('...', style: TextStyle(fontSize: 18)),
            ));
          }

          if (totalPages > 1) {
            items.add(
              ItemOffsetWidget(
                text: '$totalPages',
                isActive: page == totalPages,
                onTap: () => changePage(totalPages),
              ),
            );
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items,
        );
      },
    );
  }

  void changePage(int newPage) {
    if (newPage != currentPage.value) {
      currentPage.value = newPage;
      context.read<MangaCubit>().searchManga(
            '',
            offset: (newPage - 1) * limit,
            tags: selectedTags.isNotEmpty ? selectedTags : [widget.tag!],
          );
    }
  }

  void showBottomSheet(BuildContext context) {
    final tagCubit = context.read<TagCubit>();
    tagCubit.getTag();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: tagCubit,
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            maxChildSize: 0.9,
            minChildSize: 0.2,
            expand: true,
            builder: (context, scrollController) {
              return BlocBuilder<TagCubit, TagState>(
                builder: (context, state) {
                  if (state is TagLoaded && state.tags.isNotEmpty) {
                    return BottomSheetAppWidget(
                      listTags: state.tags,
                      onSelectTags: (listTag) {
                        filterManga(listTag.toList());
                      },
                    );
                  }
                  return Center(child: LoadingShimmer().loadingCircle());
                },
              );
            },
          ),
        );
      },
    );
  }
}
