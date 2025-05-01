import 'package:flutter/material.dart';

import '../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../core_ui/app_theme.dart/app_text_style.dart';

class AppsTextField extends StatefulWidget {
  const AppsTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  State<AppsTextField> createState() => _AppsTextFieldState();
}

class _AppsTextFieldState extends State<AppsTextField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: isObscured,
      keyboardType: widget.keyboardType,
      textAlign: TextAlign.start,
      style: AppsTextStyle.text14Weight400,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle:
            AppsTextStyle.text14Weight500.copyWith(color: AppColors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: AppColors.gray700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: AppColors.gray900),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.gray700,
                ),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
