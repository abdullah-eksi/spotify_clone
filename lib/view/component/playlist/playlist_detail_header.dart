import 'package:flutter/material.dart';
import '../../../model/playlist.dart';

class PlaylistDetailHeader extends StatelessWidget {
  final Playlist playlist;
  final bool isAppBarExpanded;
  final VoidCallback onPlayAll;
  final VoidCallback onShufflePlay;
  final VoidCallback onDownloadTap;

  const PlaylistDetailHeader({
    Key? key,
    required this.playlist,
    required this.isAppBarExpanded,
    required this.onPlayAll,
    required this.onShufflePlay,
    required this.onDownloadTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalDuration = playlist.songs.length * 3; // Ortalama 3 dakika
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    final durationText = hours > 0
        ? '$hours saat ${minutes > 0 ? '$minutes dk' : ''}'
        : '$minutes dk';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist name and info
          if (!isAppBarExpanded) ...[
            Text(
              playlist.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
          ],

          // Description if available
          if (playlist.description.isNotEmpty) ...[
            Text(
              playlist.description,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 8),
          ],

          // Creator and stats
          Text(
            'Oluşturan: ${playlist.createdBy} • ${playlist.songs.length} şarkı, $durationText',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(height: 16),

          // Control buttons
          Row(
            children: [
              // Play all
              ElevatedButton(
                onPressed: playlist.songs.isNotEmpty ? onPlayAll : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1DB954),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Çal',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),

              // Shuffle
              OutlinedButton.icon(
                onPressed: playlist.songs.isNotEmpty ? onShufflePlay : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: Icon(Icons.shuffle, size: 16),
                label: Text(
                  'Karıştır',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              Spacer(),

              // Download
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onDownloadTap,
                    child: Icon(
                      Icons.file_download_outlined,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
