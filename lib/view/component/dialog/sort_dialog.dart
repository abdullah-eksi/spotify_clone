import 'package:flutter/material.dart';

class SortDialog extends StatelessWidget {
  final List<String> sortOptions;
  final String currentSortOrder;
  final Function(String) onSortSelected;

  const SortDialog({
    Key? key,
    required this.sortOptions,
    required this.currentSortOrder,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text('Sıralama', style: TextStyle(color: Colors.white)),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: sortOptions.length,
          itemBuilder: (context, index) {
            final option = sortOptions[index];
            return ListTile(
              title: Text(option, style: TextStyle(color: Colors.white)),
              trailing: option == currentSortOrder
                  ? Icon(Icons.check, color: Color(0xFF1DB954))
                  : null,
              onTap: () {
                onSortSelected(option);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
