import 'package:flutter/material.dart';

class AlbumCover extends StatelessWidget {
  final String imageUrl;
  final double size;
  final BoxShadow? shadow;
  final double borderRadius;

  const AlbumCover({
    Key? key,
    required this.imageUrl,
    this.size = 320,
    this.shadow,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow != null ? [shadow!] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
