import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/tag_model.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({super.key, required this.listTag});
  final List<Tag> listTag;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // Khoảng cách ngang giữa các tag
      runSpacing: 8, // Khoảng cách dọc giữa các dòng tag
      children: listTag.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(2, 2),
              )
            ],
          ),
          child: Text(
            tag.attributes.name,
            style: AppsTextStyle.text13Weight500,
          ),
        );
      }).toList(),
    );
  }
}
