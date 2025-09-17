import 'package:flutter/material.dart';

class SearchHistoryItem extends StatelessWidget {
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const SearchHistoryItem({
    Key? key,
    required this.query,
    required this.onTap,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.history, color: Colors.grey),
      title: Text(query, style: TextStyle(color: Colors.white)),
      trailing: IconButton(
        icon: Icon(Icons.close, color: Colors.grey),
        onPressed: onRemove,
      ),
      onTap: onTap,
    );
  }
}
