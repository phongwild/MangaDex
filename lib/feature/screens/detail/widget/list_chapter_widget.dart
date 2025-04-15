import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
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
  final int chaptersPerPage = 15; // Số chap mỗi trang
  final ValueNotifier<List<Chapter>> chaptersNotifier =
      ValueNotifier<List<Chapter>>([]);

  @override
  void initState() {
    super.initState();
    widget.currentPage.addListener(updateChapters);
    WidgetsBinding.instance.addPostFrameCallback((_) => updateChapters());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
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
          ValueListenableBuilder<List<Chapter>>(
            valueListenable: chaptersNotifier,
            builder: (context, list, child) {
              return listChap(list);
            },
          ),
          if (widget.total > 15) listPage(widget.total) else const SizedBox(),
        ],
      ),
    );
  }

  void updateChapters() {
    if (!mounted) return;

    if (widget.listChapters.isEmpty) {
      debugPrint('⚠️ Không có dữ liệu chương, giữ danh sách cũ.');
      return;
    }

    final totalPages = (widget.listChapters.length / chaptersPerPage).ceil();
    final currentPage = widget.currentPage.value;

    // Nếu trang quá lớn, reset về trang hợp lệ
    if (currentPage > totalPages) {
      debugPrint('⚠️ Trang $currentPage quá lớn, reset về trang cuối.');
      widget.currentPage.value = totalPages;
      return; // Không gọi lại updateChapters() ngay lập tức để tránh vòng lặp vô hạn
    }

    final start = (currentPage - 1) * chaptersPerPage;
    final end = (start + chaptersPerPage).clamp(0, widget.listChapters.length);

    final newChapters = widget.listChapters.sublist(start, end);

    // Chỉ cập nhật nếu danh sách thực sự thay đổi
    if (newChapters != chaptersNotifier.value) {
      debugPrint('🔄 Cập nhật danh sách chương: từ $start đến $end');
      chaptersNotifier.value = newChapters;
    }
  }

  void changePage(int newPage) {
    if (newPage < 1 || newPage > (widget.total / chaptersPerPage).ceil()) {
      debugPrint('⚠️ Trang $newPage không hợp lệ.');
      return;
    }

    if (newPage == widget.currentPage.value) return;

    widget.currentPage.value = newPage;

    // Chỉ cập nhật nếu đã có dữ liệu
    if (widget.listChapters.isNotEmpty) {
      Future.microtask(updateChapters);
    } else {
      debugPrint('⚠️ Danh sách chương trống, chờ cập nhật dữ liệu.');
    }
  }

  // Danh sách chương
  Widget listChap(List<Chapter> list) {
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        String countryCode = list[index].translatedLanguage.toUpperCase();
        if (countryCode == 'VI') {
          countryCode = 'VN';
        } else if (countryCode == 'EN') {
          countryCode = 'US';
        }
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, NettromdexRouter.readChapter,
                arguments: ReadChapterPage(
                  idChapter: list[index].id,
                  idManga: widget.idManga,
                  listChapters: widget.listChapters,
                  chapter: list[index].chapter,
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
                    color: AppColors.black.withOpacity(0.3),
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
                  'C. ${list[index].chapter}',
                  style: AppsTextStyle.text14Weight600,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        list[index].title ?? 'N/a',
                        style: AppsTextStyle.text14Weight400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(timeAgo(list[index].updatedAt.toString()),
                          style: AppsTextStyle.text12Weight400
                              .copyWith(color: AppColors.gray700)),
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

  Widget listPage(int total) {
    final totalPages = (total / chaptersPerPage).ceil();
    if (totalPages <= 0) return const SizedBox();
    if (totalPages <= 1) return const SizedBox();

    return ValueListenableBuilder<int>(
      valueListenable: widget.currentPage,
      builder: (context, page, child) {
        List<Widget> items = [];

        items.add(ItemOffsetWidget(
          text: '1',
          isActive: page == 1,
          onTap: () => changePage(1),
        ));

        if (totalPages <= 5) {
          for (int i = 2; i <= totalPages; i++) {
            items.add(ItemOffsetWidget(
              text: '$i',
              isActive: page == i,
              onTap: () => changePage(i),
            ));
          }
        } else {
          if (page > 3) {
            items.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text('...', style: AppsTextStyle.text18Weight400),
            ));
          }

          int start = (page - 1).clamp(2, totalPages - 3).toInt();
          int end = (page + 1).clamp(4, totalPages - 1).toInt();

          for (int i = start; i <= end; i++) {
            items.add(ItemOffsetWidget(
              text: '$i',
              isActive: page == i,
              onTap: () => changePage(i),
            ));
          }

          if (page < totalPages - 2) {
            items.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text('...', style: AppsTextStyle.text18Weight400),
            ));
          }

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
}
