import 'package:flutter/material.dart';
import '../../../model/song.dart';
import '../../../service/favorite_service.dart';

class SongOptionsBottomSheet extends StatelessWidget {
  final Song song;
  final VoidCallback onAddToPlaylistTap;
  final VoidCallback onShareTap;
  final VoidCallback onFavoriteToggle;

  const SongOptionsBottomSheet({
    Key? key,
    required this.song,
    required this.onAddToPlaylistTap,
    required this.onShareTap,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              FavoriteService.isSongFavorite(song.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
            ),
            title: Text(
              FavoriteService.isSongFavorite(song.id)
                  ? 'Favorilerden çıkar'
                  : 'Favorilere ekle',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              onFavoriteToggle();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.playlist_add, color: Colors.white),
            title: Text(
              'Çalma listesine ekle',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              onAddToPlaylistTap();
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Colors.white),
            title: Text('Paylaş', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              onShareTap();
            },
          ),
          ListTile(
            leading: Icon(Icons.album, color: Colors.white),
            title: Text('Albüme git', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Albüm sayfası (yapım aşamasında)')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text('Sanatçıya git', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sanatçı sayfası (yapım aşamasında)')),
              );
            },
          ),
        ],
      ),
    );
  }
}
