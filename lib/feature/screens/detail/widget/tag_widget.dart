import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/tag_model.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.listTag,
    required this.onTap,
    this.isEnable = true,
  });

  final List<Tag> listTag;
  final Function(Tag) onTap;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: listTag.map((tag) {
        final selectedTagNotifier = ValueNotifier<bool>(false);

        return ValueListenableBuilder<bool>(
          valueListenable: selectedTagNotifier,
          builder: (context, isSelected, _) {
            return GestureDetector(
              onTap: isEnable
                  ? () {
                      selectedTagNotifier.value = !isSelected;
                      onTap(tag);
                    }
                  : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xff2563eb) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  tag.attributes.name,
                  style: AppsTextStyle.text13Weight500.copyWith(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
