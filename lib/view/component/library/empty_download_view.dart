import 'package:flutter/material.dart';

class EmptyDownloadView extends StatelessWidget {
  const EmptyDownloadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download_done_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Henüz indirilen yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'İndirdiğiniz şarkılar burada görünecek',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
