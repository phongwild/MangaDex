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
}
