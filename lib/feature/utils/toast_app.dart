import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

void showToast(String msg, {bool isError = false}) {
  showSimpleNotification(
    _buildToastContent(msg, isError),
    background: Colors.transparent, // Làm nền trong suốt để thấy hiệu ứng blur
    duration: const Duration(seconds: 2),
    slideDismiss: true,
  );
}

Widget _buildToastContent(String msg, bool isError) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12), // Bo góc iOS-style
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Hiệu ứng kính mờ
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Màu trắng mờ giống iOS
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Colors.white.withOpacity(0.4)), // Tạo viền nhẹ
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? Colors.redAccent : Colors.green,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              msg,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
