import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.gray300, height: 0.5, width: double.infinity);
  }
}
