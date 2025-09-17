import 'package:flutter/material.dart';

class LibrarySortBar extends StatelessWidget {
  final String sortOrder;
  final bool isGridView;
  final VoidCallback onSortTap;
  final VoidCallback onViewToggle;

  const LibrarySortBar({
    Key? key,
    required this.sortOrder,
    required this.isGridView,
    required this.onSortTap,
    required this.onViewToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onSortTap,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Text(
                    sortOrder,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isGridView ? Icons.list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: onViewToggle,
            tooltip: isGridView
                ? 'Liste görünümüne geç'
                : 'Izgara görünümüne geç',
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
