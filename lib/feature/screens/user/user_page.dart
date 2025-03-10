import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BodyPage();
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage();

  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1d5db),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: buildUserInfo(),
        ),
      ),
    );
  }
}

Widget buildUserInfo() {
  return Container(
    padding: const EdgeInsets.all(16),
    alignment: Alignment.center,
    width: double.infinity,
    child: Text(
      'Tính năng đang phát triển :))',
      style: AppsTextStyle.text14Weight400,
    ),
  );
}
