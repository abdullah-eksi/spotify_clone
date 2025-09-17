import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function() onSearchTap;
  final Function(String) onSearchChanged;

  const SearchAppBar({
    Key? key,
    required this.searchController,
    required this.onSearchTap,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          'Ara',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: TextField(
            controller: searchController,
            onTap: onSearchTap,
            onChanged: onSearchChanged,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Ne dinlemek istiyorsun?',
              hintStyle: TextStyle(color: Colors.black54),
              prefixIcon: Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
