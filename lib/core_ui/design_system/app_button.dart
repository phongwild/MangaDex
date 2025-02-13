import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_color/color_theme/color_define.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton(
      {super.key,
      this.onPressed,
      this.enable = true,
      this.colorEnable,
      this.action,
      this.colorBorder,
      this.colorDisable,
      this.borderRadius = 8,
      this.actionWidget,
      this.textStyle,
      this.padding,
      this.loading,
      this.overlayColor = true});
  final VoidCallback? onPressed;
  final String? action;
  final Widget? actionWidget;
  final bool enable;
  final Color? colorEnable;
  final Color? colorBorder;
  final Color? colorDisable;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final bool? loading;
  final bool overlayColor;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _singleTap = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.enable
          ? () {
              if (!_singleTap) {
                widget.onPressed!();
                _singleTap = true;
                Future.delayed(const Duration(seconds: 2))
                    .then((value) => _singleTap = false);
              }
            }
          : null,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (!widget.overlayColor) {
              return null;
            }
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xff327DFB);
            }
            return null;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              side: BorderSide(
                  width: 1, color: widget.colorBorder ?? Colors.transparent)),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(widget.padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        backgroundColor: MaterialStateProperty.all<Color>(
          widget.enable
              ? (widget.colorEnable ?? ColorDefine.kssPrimary)
              : (widget.colorDisable ?? ColorDefine.gray500.withOpacity(0.7)),
        ),
      ),
      child: SizedBox(
        height: 22,
        width: double.infinity,
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.actionWidget ??
                  Text(
                    widget.action ?? '',
                    style: widget.textStyle ??
                        TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: widget.enable
                                ? AppColors.white
                                : AppColors.white),
                    textAlign: TextAlign.center,
                  ),
              Visibility(
                visible: widget.loading ?? false,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
