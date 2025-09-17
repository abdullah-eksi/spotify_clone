import 'package:flutter/material.dart';
import '../../../model/song.dart';
import '../../../service/favorite_service.dart';

class SongOptionsMenu extends StatelessWidget {
  final Song song;
  final VoidCallback onAddToQueue;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onGoToAlbum;
  final VoidCallback onShare;

  const SongOptionsMenu({
    Key? key,
    required this.song,
    required this.onAddToQueue,
    required this.onAddToPlaylist,
    required this.onFavoriteToggle,
    required this.onGoToAlbum,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              song.imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(song.title, style: TextStyle(color: Colors.white)),
          subtitle: Text(song.artist, style: TextStyle(color: Colors.grey)),
        ),
        Divider(color: Colors.white24),
        ListTile(
          leading: Icon(Icons.add_to_queue, color: Colors.white),
          title: Text(
            'Çalma sırasına ekle',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);
            onAddToQueue();
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
            onAddToPlaylist();
          },
        ),
        ListTile(
          leading: Icon(
            FavoriteService.isSongFavorite(song.id)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.white,
          ),
          title: Text(
            FavoriteService.isSongFavorite(song.id)
                ? 'Beğenmekten vazgeç'
                : 'Beğen',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);
            onFavoriteToggle();
          },
        ),
        ListTile(
          leading: Icon(Icons.album, color: Colors.white),
          title: Text('Albüme git', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            onGoToAlbum();
          },
        ),
        ListTile(
          leading: Icon(Icons.share, color: Colors.white),
          title: Text('Paylaş', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context);
            onShare();
          },
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
