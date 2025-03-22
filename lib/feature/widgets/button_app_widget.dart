import 'package:flutter/material.dart';

import '../../core_ui/app_theme.dart/app_text_style.dart';

class ButtonAppWidget extends StatefulWidget {
  const ButtonAppWidget({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onTap,
    required this.isBoxShadow,
    this.width = double.infinity,
    this.height = 45,
    this.leadingIcon, // Thêm thuộc tính mới
  });

  final String text;
  final Color color;
  final Color textColor;
  final bool isBoxShadow;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final Widget? leadingIcon; // Widget tùy chọn

  @override
  State<ButtonAppWidget> createState() => _ButtonAppWidgetState();
}

class _ButtonAppWidgetState extends State<ButtonAppWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            widget.isBoxShadow
                ? BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(4, 4),
                  )
                : const BoxShadow(),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Đảm bảo không bị dàn rộng toàn bộ
          children: [
            if (widget.leadingIcon != null) ...[
              widget.leadingIcon!,
              const SizedBox(width: 8), // Khoảng cách giữa icon và text
            ],
            Text(
              widget.text,
              style: AppsTextStyle.text14Weight500
                  .copyWith(color: widget.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
