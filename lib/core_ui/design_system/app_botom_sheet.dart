//import 'dart:developer' as developer;

import 'package:app/common/define/app_size.dart';
import 'package:app/core_ui/app_theme.dart/app_color/color_theme/color_define.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget child;

  const AppBottomSheet({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.only(
            top: 8,
            left: 8,
            right: 16,
            bottom: 12 + MediaQuery.paddingOf(context).bottom),
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            color: ColorDefine.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12))),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close,
                      size: AppSize.k26, color: ColorDefine.gray900)),
              const Gap(AppSize.k8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSize.k16),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
