// ignore_for_file: non_constant_identifier_names

import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/screens/search/widgets/item_manga_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../core_ui/widget/loading/loading.dart';

class MoreMangaPage extends StatefulWidget {
  const MoreMangaPage({super.key});

  @override
  State<MoreMangaPage> createState() => _MoreMangaPageState();
}

class _MoreMangaPageState extends State<MoreMangaPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MangaCubit()
        ..getManga(
          isLatestUploadedChapter: true,
          limit: 25,
          offset: 0,
          translateLang: 'vi',
        ),
      child: const _BodyPage(),
    );
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage();

  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  final ValueNotifier<int> totals = ValueNotifier(0);
  final ValueNotifier<int> currentPage = ValueNotifier(1);
  final int limit = 25;

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
          icon: const Icon(IconlyBold.arrowLeft2),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  BlocBuilder<MangaCubit, MangaState>(
                    builder: (context, state) {
                      if (state is MangaLoading) {
                        return const Expanded(
                          child: Center(
                            child: VPBankLoading(),
                          ),
                        );
                      }
                      if (state is MangaError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }
                      if (state is MangaLoaded) {
                        final mangas = state.mangas;
                        totals.value = state.total ?? 0;
                        return Expanded(
                            child: ItemMangaWidget(mangaList: mangas));
                      }
                      return const SizedBox(height: 10);
                    },
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<int>(
                  valueListenable: totals,
                  builder: (context, totalValue, child) {
                    return ListPage(totalValue);
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
    final int totalPages = (totals / limit).ceil();
    if (totalPages <= 1) return const SizedBox();

    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (context, page, child) {
        List<Widget> items = [];

        // Page đầu tiên
        items.add(ItemOffset('1', page == 1, () => changePage(1)));

        // Nếu trang hiện tại > 3, hiển thị dấu `...`
        if (page > 3) {
          items.add(const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text('...', style: TextStyle(fontSize: 18)),
          ));
        }

        // Hiển thị các số trang xung quanh trang hiện tại
        int start = (page - 1).clamp(2, totalPages - 3);
        int end = (page + 1).clamp(4, totalPages - 1);

        for (int i = start; i <= end; i++) {
          items.add(ItemOffset('$i', page == i, () => changePage(i)));
        }

        // Nếu trang hiện tại cách trang cuối nhiều hơn 2, hiển thị dấu `...`
        if (page < totalPages - 2) {
          items.add(const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text('...', style: TextStyle(fontSize: 18)),
          ));
        }

        // Page cuối cùng
        if (totalPages > 1) {
          items.add(ItemOffset(
              '$totalPages', page == totalPages, () => changePage(totalPages)));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items,
        );
      },
    );
  }

  Widget ItemOffset(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : const Color(0xff374151),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppsTextStyle.text14Weight600
              .copyWith(color: isActive ? Colors.white : Colors.grey[300]),
        ),
      ),
    );
  }

  void changePage(int newPage) {
    if (newPage != currentPage.value) {
      currentPage.value = newPage;
      context.read<MangaCubit>().getManga(
            isLatestUploadedChapter: true,
            limit: limit,
            offset: (newPage - 1) * limit,
            translateLang: 'vi',
          );
    }
  }
}
