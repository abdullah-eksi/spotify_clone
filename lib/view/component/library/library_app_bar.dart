import 'package:flutter/material.dart';

class LibraryAppBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onAddTap;

  const LibraryAppBar({
    Key? key,
    required this.onSearchTap,
    required this.onAddTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF1DB954),
                child: Text(
                  'K',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Kütüphaneniz',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: onSearchTap,
                splashRadius: 20,
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: onAddTap,
                tooltip: 'Yeni çalma listesi oluştur',
                splashRadius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
