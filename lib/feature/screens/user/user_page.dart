import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Tính năng đang phát triển',
          style: AppsTextStyle.text14Weight500,
        ),
      ),
    );
  }
}
