import 'package:flutter/material.dart';
import '../../service/playlist_manager.dart';

class CreatePlaylistPage extends StatefulWidget {
  const CreatePlaylistPage({Key? key}) : super(key: key);

  @override
  _CreatePlaylistPageState createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCreating = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createPlaylist() {
    setState(() {
      _errorMessage = null;
      _isCreating = true;
    });

    // Boş isim kontrolü
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Çalma listesi için bir ad girin';
        _isCreating = false;
      });
      return;
    }

    // Playlist oluştur
    final playlist = PlaylistManager().createPlaylist(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    setState(() {
      _isCreating = false;
    });

    // Başarı mesajı ve önceki sayfaya dön
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${playlist.name} çalma listesi oluşturuldu'),
        backgroundColor: Color(0xFF1DB954),
      ),
    );
    Navigator.pop(context, playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Yeni Çalma Listesi'),
        actions: [
          TextButton(
            onPressed: _isCreating ? null : _createPlaylist,
            style: TextButton.styleFrom(foregroundColor: Color(0xFF1DB954)),
            child: Text('OLUŞTUR'),
          ),
        ],
      ),
      body: _isCreating
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1DB954)),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kapak resmi ekleme alanı
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.music_note,
                          size: 50,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Çalma listesi adı
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Çalma listesi adı',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      errorText: _errorMessage,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16),

                  // Açıklama
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Açıklama ekle',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    minLines: 3,
                    maxLines: 5,
                  ),
                  SizedBox(height: 24),

                  // Bilgi metni
                  Text(
                    'Çalma listenizi oluşturduktan sonra daha fazla şarkı ekleyebilirsiniz.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
    );
  }
}
