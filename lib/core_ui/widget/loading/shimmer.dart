import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer {
  static final LoadingShimmer _singleton = LoadingShimmer._internal();
  factory LoadingShimmer() => _singleton;
  LoadingShimmer._internal();

  /// base shimmer
  Widget _shimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }

  Widget line({double width = 100, double height = 30}) {
    return _shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget list() {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _shimmer(
            child: Row(
              children: [
                /// avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                /// text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget loadingCircle({double size = 24, Color? color}) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: size / 2,
        color: color ?? Colors.grey[600],
      ),
    );
  }

  /// avatar shimmer
  Widget loadingAvatar({double width = 95, double height = 95}) {
    return Center(
      child: _shimmer(
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
