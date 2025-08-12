import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:flutter/cupertino.dart';

class DialogSetting extends StatelessWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const DialogSetting({
    super.key,
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: AppsTextStyle.text14Weight500.copyWith(color: AppColors.gray900),
        textAlign: TextAlign.center,
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: onConfirm,
          child: Text(
            confirmText,
            style: AppsTextStyle.text13Weight500
                .copyWith(color: AppColors.gray900),
          ),
        ),
        CupertinoDialogAction(
          onPressed: onCancel ?? () => Navigator.pop(context),
          child: Text(
            cancelText,
            style: AppsTextStyle.text13Weight500
                .copyWith(color: AppColors.gray900),
          ),
        ),
      ],
    );
  }
}
