import 'package:flutter/material.dart';

class OptimizedListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget? separatorBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final double? cacheExtent;

  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.cacheExtent,
  });

  @override
  Widget build(BuildContext context) {
    // Use ListView.builder for better performance with large lists
    if (separatorBuilder != null) {
      return ListView.separated(
        controller: controller,
        padding: padding,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        shrinkWrap: shrinkWrap,
        itemCount: itemCount,
        // Increase cache extent for smoother scrolling
        cacheExtent: cacheExtent ?? MediaQuery.of(context).size.height * 2,
        // Add keys for better performance
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) => separatorBuilder!,
      );
    }

    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      // Increase cache extent for smoother scrolling
      cacheExtent: cacheExtent ?? MediaQuery.of(context).size.height * 2,
      // Add keys for better performance
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: itemBuilder,
    );
  }
}

// Optimized GridView for grid layouts
class OptimizedGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final double? cacheExtent;

  const OptimizedGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.cacheExtent,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      gridDelegate: gridDelegate,
      // Increase cache extent for smoother scrolling
      cacheExtent: cacheExtent ?? MediaQuery.of(context).size.height * 2,
      // Add keys for better performance
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemBuilder: itemBuilder,
    );
  }
}