import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../reading/read_chapter_page.dart';

class ListChapterWidget extends StatefulWidget {
  const ListChapterWidget(
      {super.key, required this.listChapters, required this.idManga});
  final List<Chapter> listChapters;
  final String idManga;
  @override
  State<ListChapterWidget> createState() => _ListChapterWidgetState();
}

class _ListChapterWidgetState extends State<ListChapterWidget> {
  String timeAgo(String utcDateTime) {
    try {
      // 1️⃣ Parse chuỗi thời gian từ UTC
      DateTime utcTime = DateTime.parse(utcDateTime);

      // 2️⃣ Chuyển sang múi giờ Việt Nam (GMT+7)
      DateTime updateTime = utcTime.toUtc().add(const Duration(hours: 7));

      // 3️⃣ Lấy thời gian hiện tại theo múi giờ Việt Nam
      DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));

      // 4️⃣ Tính khoảng cách thời gian
      Duration difference = now.difference(updateTime);

      // 5️⃣ Hiển thị thời gian theo kiểu "X năm X tháng X ngày X giờ X phút trước"
      if (difference.inDays >= 365) {
        int years = (difference.inDays / 365).floor();
        return '$years năm trước';
      } else if (difference.inDays >= 30) {
        int months = (difference.inDays / 30).floor();
        return '$months tháng trước';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ngày trước';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} giờ trước';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} phút trước';
      } else {
        return 'Vừa mới cập nhật';
      }
    } catch (e) {
      return 'Lỗi định dạng ngày giờ';
    }
  }

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
          ListView.builder(
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
                  Navigator.pushNamed(context, '/read-chapter',
                      arguments: ReadChapterPage(
                        idChapter: widget.listChapters[index].id,
                        idManga: widget.idManga,
                        listChapters: widget.listChapters,
                      ));
                },
                child: Container(
                  height: 45,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                timeAgo(widget.listChapters[index].updatedAt
                                    .toString()),
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
          ),
        ],
      ),
    );
  }
}
