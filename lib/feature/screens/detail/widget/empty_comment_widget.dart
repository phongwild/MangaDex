import 'package:flutter/cupertino.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class EmptyComment extends StatelessWidget {
  const EmptyComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.buttonDisablePopup,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Chưa có bình luận nào (⁠´⁠；⁠ω⁠；⁠｀⁠)',
        style: AppsTextStyle.text14Weight400.copyWith(
          color: AppColors.gray700,
        ),
      ),
    );
  }
}
