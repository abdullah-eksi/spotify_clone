import 'package:flutter/material.dart';

class ScrollableItemList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, int) itemBuilder;
  final double height;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;

  const ScrollableItemList({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.height = 200,
    this.itemSpacing = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(bottom: 24),
      child: ListView.builder(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: itemSpacing),
            child: itemBuilder(context, index),
          );
        },
      ),
    );
  }
}
