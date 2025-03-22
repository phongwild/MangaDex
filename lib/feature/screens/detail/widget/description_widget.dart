import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget({super.key, required this.desc});
  final String desc;

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  final ValueNotifier<bool> isExpanded = ValueNotifier(false);

  @override
  void dispose() {
    isExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppsTextStyle.text14Weight500.copyWith(
      color: const Color(0xff6b7280),
    );

    // Đo kích thước của văn bản
    final textSpan = TextSpan(text: widget.desc, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 5,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);

    final isTooLong = textPainter.didExceedMaxLines;

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffedeef1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: isExpanded,
          builder: (context, expanded, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Linkify(
                  onOpen: (link) async {
                    String fixedUrl = link.url.trim(); // Loại bỏ khoảng trắng

                    // Xử lý URL sai định dạng
                    while (fixedUrl.endsWith(")") ||
                        fixedUrl.endsWith(".") ||
                        fixedUrl.endsWith(",")) {
                      fixedUrl = fixedUrl.substring(0, fixedUrl.length - 1);
                    }

                    // Kiểm tra URL hợp lệ
                    Uri? uri;
                    try {
                      uri = Uri.parse(fixedUrl);
                      if (uri.scheme.isEmpty) {
                        throw Exception("URL không có scheme (http/https)");
                      }
                    } catch (e) {
                      showToast('Link không hợp lệ: $fixedUrl', isError: true);
                      return;
                    }

                    // Mở WebView
                    Navigator.pushNamed(
                      context,
                      NettromdexRouter.webView,
                      arguments: fixedUrl,
                    );
                  },
                  text: widget.desc,
                  style: textStyle,
                  textAlign: TextAlign.justify,
                  maxLines: expanded ? null : 5,
                  overflow:
                      expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                if (isTooLong)
                  InkWell(
                    onTap: () {
                      isExpanded.value = !expanded;
                    },
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          expanded ? "Thu gọn" : "Xem thêm",
                          style: AppsTextStyle.text14Weight600
                              .copyWith(color: const Color(0xff2563eb)),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
