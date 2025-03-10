import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class LoadingShimmer {
  static final LoadingShimmer _singleton = LoadingShimmer._internal();
  factory LoadingShimmer() => _singleton;
  LoadingShimmer._internal();

  Widget line() {
    return SkeletonLine(
      style:
          SkeletonLineStyle(height: 30, borderRadius: BorderRadius.circular(6)),
    );
  }

  Widget list() {
    return ListView.builder(
        itemCount: 15,
        itemBuilder: (ctx, index) {
          return SkeletonListTile(hasSubtitle: true);
        });
  }

  /// Hiệu ứng loading iOS xoay xoay
  Widget loadingCircle({double size = 24, Color? color}) {
    return Center(
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: CupertinoActivityIndicator(
          radius: size / 2, // Để kích thước chuẩn iOS
          color: color ?? Colors.grey[600],
        ),
      ),
    );
  }
}
