import 'package:app/core/app_log.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/cubit/detail_manga_cubit.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../more/widget/item_offset_widget.dart';
import '../../reading/read_chapter_page.dart';

class ListChapterWidget extends StatefulWidget {
  const ListChapterWidget({
    super.key,
    required this.listChapters,
    required this.idManga,
    required this.total,
    required this.currentPage,
  });
  final List<Chapter> listChapters;
  final String idManga;
  final int total;
  final ValueNotifier<int> currentPage;
  @override
  State<ListChapterWidget> createState() => _ListChapterWidgetState();
}

class _ListChapterWidgetState extends State<ListChapterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh sách Chap:',
            style: AppsTextStyle.text14Weight600,
          ),
          const SizedBox(height: 10),
          listChap(),
          if (widget.total > 15) listPage(widget.total) else const SizedBox(),
        ],
      ),
    );
  }

  //danh sách chương
  Widget listChap() {
    return ListView.builder(
      itemCount: widget.listChapters.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        String countryCode =
            widget.listChapters[index].translatedLanguage.toUpperCase();
        if (countryCode == 'VI') {
          countryCode = 'VN';
        } else if (countryCode == 'EN') {
          countryCode = 'US';
        }
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, NettromdexRouter.readChapter,
                arguments: ReadChapterPage(
                  idChapter: widget.listChapters[index].id,
                  idManga: widget.idManga,
                  listChapters: widget.listChapters,
                  chapter: widget.listChapters[index].chapter,
                ));
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: const Color(0xffedeef1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    spreadRadius: 1,
                    offset: const Offset(0, 1),
                  )
                ]),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CountryFlag.fromCountryCode(
                  countryCode,
                  height: 20,
                  width: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  'C. ${widget.listChapters[index].chapter}',
                  style: AppsTextStyle.text14Weight600,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.listChapters[index].title ?? 'N/a',
                        style: AppsTextStyle.text14Weight400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                          timeAgo(
                              widget.listChapters[index].updatedAt.toString()),
                          style: AppsTextStyle.text12Weight400
                              .copyWith(color: const Color(0xff6b7280))),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget listPage(int totals) {
    final int totalPages = (totals > 0) ? (totals / 15).ceil() : 1;
    if (totalPages <= 0) return const SizedBox();
    if (totalPages <= 1) return const SizedBox();

    return ValueListenableBuilder<int>(
      valueListenable: widget.currentPage,
      builder: (context, page, child) {
        List<Widget> items = [];

        // Trang đầu tiên
        items.add(ItemOffsetWidget(
          text: '1',
          isActive: page == 1,
          onTap: () => changePage(1),
        ));

        if (totalPages <= 5) {
          // Nếu tổng trang <= 3, hiển thị tất cả các trang
          for (int i = 2; i <= totalPages; i++) {
            items.add(ItemOffsetWidget(
              text: '$i',
              isActive: page == i,
              onTap: () => changePage(i),
            ));
          }
        } else {
          // Nếu trang hiện tại > 3, hiển thị dấu `...`
          if (page > 3) {
            items.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text('...', style: AppsTextStyle.text18Weight400),
            ));
          }

          // Hiển thị các trang xung quanh trang hiện tại
          int start = (page - 1).clamp(2, totalPages - 3).toInt();
          int end = (page + 1).clamp(4, totalPages - 1).toInt();

          for (int i = start; i <= end; i++) {
            items.add(ItemOffsetWidget(
              text: '$i',
              isActive: page == i,
              onTap: () => changePage(i),
            ));
          }

          // Dấu "..." trước trang cuối nếu cần
          if (page < totalPages - 2) {
            items.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text('...', style: AppsTextStyle.text18Weight400),
            ));
          }

          // Trang cuối
          items.add(ItemOffsetWidget(
            text: '$totalPages',
            isActive: page == totalPages,
            onTap: () => changePage(totalPages),
          ));
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
    if (newPage != widget.currentPage.value) {
      widget.currentPage.value = newPage;
      context.read<DetailMangaCubit>().getDetailManga(
            widget.idManga,
            true,
            offset: (newPage - 1) * 15,
          );
    }
  }
}
