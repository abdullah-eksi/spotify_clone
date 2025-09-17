import 'package:flutter/material.dart';
import '../../../model/song.dart';
import '../../../service/favorite_service.dart';

class PlaylistSongItem extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;
  final int index;

  const PlaylistSongItem({
    Key? key,
    required this.song,
    required this.onTap,
    required this.onMoreTap,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Image.network(
                  song.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  color: Colors.black54,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            song.title,
            style: TextStyle(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.artist,
            style: TextStyle(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  FavoriteService.isSongFavorite(song.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: FavoriteService.isSongFavorite(song.id)
                      ? Color(0xFF1DB954)
                      : Colors.white70,
                  size: 20,
                ),
                onPressed: () {
                  FavoriteService.toggleSongFavorite(song.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        FavoriteService.isSongFavorite(song.id)
                            ? 'Favorilere eklendi'
                            : 'Favorilerden çıkarıldı',
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white70, size: 20),
                onPressed: onMoreTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
