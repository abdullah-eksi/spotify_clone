import 'package:flutter/material.dart';
import '../../../model/playlist.dart';
import '../../../service/favorite_service.dart';

class PlaylistOptionsBottomSheet extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onFavoriteToggle;

  const PlaylistOptionsBottomSheet({
    Key? key,
    required this.playlist,
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
              FavoriteService.isPlaylistFavorite(playlist.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
            ),
            title: Text(
              FavoriteService.isPlaylistFavorite(playlist.id)
                  ? 'Favorilerden çıkar'
                  : 'Favorilere ekle',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              onFavoriteToggle();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    FavoriteService.isPlaylistFavorite(playlist.id)
                        ? 'Favorilere eklendi'
                        : 'Favorilerden çıkarıldı',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.download, color: Colors.white),
            title: Text('İndir', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Çalma listesi indiriliyor')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Colors.white),
            title: Text('Paylaş', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Çalma listesi paylaşılıyor')),
              );
            },
          ),
        ],
      ),
    );
  }
}
