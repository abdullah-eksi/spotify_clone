import 'package:flutter/material.dart';

class SearchHistoryList extends StatelessWidget {
  final List<String> searchHistory;
  final Function(String) onItemTap;
  final Function(String) onItemRemove;

  const SearchHistoryList({
    Key? key,
    required this.searchHistory,
    required this.onItemTap,
    required this.onItemRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recent searches',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ...searchHistory
              .map(
                (item) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    child: Icon(Icons.music_note, color: Colors.white),
                  ),
                  title: Text(item, style: TextStyle(color: Colors.white)),
                  onTap: () => onItemTap(item),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.white60),
                    onPressed: () => onItemRemove(item),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
