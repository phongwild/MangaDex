import 'package:flutter/material.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget({super.key, required this.desc});
  final String desc;

  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffedeef1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Text(
            widget.desc,
            style: AppsTextStyle.text14Weight500.copyWith(
              color: const Color(0xff6b7280),
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
