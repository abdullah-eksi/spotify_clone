import 'package:flutter/material.dart';
import '../../../model/playlist.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback? onTap;

  const PlaylistCard({required this.playlist, this.onTap, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap:
            onTap ??
            () {
              // Çalma listesi detay sayfasına yönlendir
              Navigator.pushNamed(
                context,
                '/playlist_detail',
                arguments: playlist,
              );
            },
        child: SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  playlist.imageUrl,
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                playlist.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'By ${playlist.createdBy}',
                style: TextStyle(color: Colors.white70, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
