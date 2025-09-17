import 'package:flutter/material.dart';

class AddPlaylistDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final Function(String) onPlaylistCreated;

  AddPlaylistDialog({Key? key, required this.onPlaylistCreated})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        'Çalma Listesi Oluştur',
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Çalma listesi adı',
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1DB954)),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('İptal', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              onPlaylistCreated(name);
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1DB954)),
          child: Text('Oluştur'),
        ),
      ],
    );
  }
}
