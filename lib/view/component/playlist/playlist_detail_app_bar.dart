import 'package:flutter/material.dart';
import '../../../model/playlist.dart';
import '../../../service/favorite_service.dart';

class PlaylistDetailAppBar extends StatelessWidget {
  final Playlist playlist;
  final bool isExpanded;
  final VoidCallback onMoreTap;
  final VoidCallback onFavoriteTap;
  final double expandedHeight;

  const PlaylistDetailAppBar({
    Key? key,
    required this.playlist,
    required this.isExpanded,
    required this.onMoreTap,
    required this.onFavoriteTap,
    this.expandedHeight = 240.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: isExpanded ? Colors.black : Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: isExpanded
            ? Text(playlist.name, style: TextStyle(color: Colors.white))
            : null,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Playlist cover image with blur effect
            Image.network(playlist.imageUrl, fit: BoxFit.cover),
            // Overlay gradient for better visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                  stops: [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            FavoriteService.isPlaylistFavorite(playlist.id)
                ? Icons.favorite
                : Icons.favorite_border,
            color: FavoriteService.isPlaylistFavorite(playlist.id)
                ? Color(0xFF1DB954)
                : Colors.white,
          ),
          onPressed: onFavoriteTap,
        ),
        IconButton(icon: Icon(Icons.more_vert), onPressed: onMoreTap),
      ],
    );
  }
}
