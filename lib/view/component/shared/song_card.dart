import 'package:flutter/material.dart';
import '../../../model/song.dart';
import '../../../service/favorite_service.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;
  final bool isPlaying;
  final bool showFavorite;

  const SongCard({
    Key? key,
    required this.song,
    this.onTap,
    this.onMoreTap,
    this.isPlaying = false,
    this.showFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isPlaying
          ? Colors.grey.withOpacity(0.3)
          : Colors.grey.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  song.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPlaying ? Color(0xFF1DB954) : Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      song.artist,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (showFavorite)
                IconButton(
                  icon: Icon(
                    FavoriteService.isSongFavorite(song.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: FavoriteService.isSongFavorite(song.id)
                        ? Color(0xFF1DB954)
                        : Colors.white,
                    size: 22,
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
                icon: Icon(
                  onMoreTap != null ? Icons.more_vert : Icons.play_arrow,
                  color: isPlaying ? Color(0xFF1DB954) : Colors.white,
                  size: 24,
                ),
                onPressed: onMoreTap ?? onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
