import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({Key? key, required this.title, this.onSeeAllTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (onSeeAllTap != null)
            InkWell(
              onTap: onSeeAllTap,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'TÜMÜNÜ GÖR',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
