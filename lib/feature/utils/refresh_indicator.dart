import 'package:app/core_ui/widget/loading/loading.dart';
import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Colors.transparent, // Ẩn vòng tròn mặc định
      backgroundColor: Colors.transparent,
      strokeWidth: 0,
      child: Stack(
        children: [
          child,
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 50,
                width: 50,
                child: const VPBankLoading()),
          ),
        ],
      ),
    );
  }
}
