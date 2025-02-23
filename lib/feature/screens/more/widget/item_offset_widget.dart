import 'package:flutter/material.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class ItemOffsetWidget extends StatelessWidget {
  const ItemOffsetWidget({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  final String text;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xff2563eb) : const Color(0xffffffff),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(2, 2),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(2, 2),
                  )
                ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppsTextStyle.text14Weight600
              .copyWith(color: isActive ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
