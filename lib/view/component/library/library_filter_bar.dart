import 'package:flutter/material.dart';

class LibraryFilterBar extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const LibraryFilterBar({
    Key? key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: selectedFilter == filter,
                onSelected: (bool selected) {
                  if (selected) {
                    onFilterSelected(filter);
                  }
                },
                backgroundColor: Colors.grey[900],
                selectedColor: Colors.white,
                checkmarkColor: Colors.black,
                labelStyle: TextStyle(
                  color: selectedFilter == filter ? Colors.black : Colors.white,
                  fontWeight: selectedFilter == filter
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
