import 'package:flutter/material.dart';
import '../../../model/song.dart';

class TrackInfo extends StatelessWidget {
  final Song song;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const TrackInfo({
    Key? key,
    required this.song,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song.artist,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Color(0xFF1DB954) : Colors.white,
              size: 28,
            ),
            splashColor: Colors.white24,
            splashRadius: 24,
            tooltip: isFavorite ? 'Favorilerden çıkar' : 'Favorilere ekle',
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}
