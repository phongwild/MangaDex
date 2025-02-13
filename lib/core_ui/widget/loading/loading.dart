import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:app/common/define/app_size.dart';
import 'package:app/common/define/key_assets.dart';
import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/global/router/app_router.dart';

class VPBankLoading extends StatelessWidget {
  const VPBankLoading({super.key, this.size = 70});
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(KeyAssets.jsonLoading),
    );
  }
}

loading({bool isNoText = true}) {
  final context = navigation.navigatorKey.currentContext;
  if (context == null) {
    return;
  }
  showDialog(
      barrierColor: AppColors.bgLoading,
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (isNoText) {
          return SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Center(
                child: Container(
                    padding: const EdgeInsets.all(AppSize.k6),
                    decoration: BoxDecoration(
                        color: AppColors.bgPopup,
                        borderRadius: BorderRadius.circular(AppSize.k16)),
                    child: const VPBankLoading(
                      size: AppSize.k44,
                    ))),
          );
        }
        return AlertDialog(
          backgroundColor: AppColors.bgPopup,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSize.k24),
          content: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.k18)),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const VPBankLoading(),
                    const SizedBox(height: AppSize.k16),
                    Text('',
                        style: AppsTextStyle.text14Weight400
                            .copyWith(color: AppColors.gray500)),
                  ],
                ),
              )),
        );
      });
}

hideLoading() {
  final context = navigation.navigatorKey.currentContext;
  if (context == null) {
    return;
  }
  Navigator.pop(context);
}
