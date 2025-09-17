import 'package:flutter/material.dart';
import '../../../model/song.dart';

class ArtistTopTracksSection extends StatelessWidget {
  final List<Song> tracks;
  final Function(Song) onTrackTap;
  final Function(Song) onMoreOptionsTap;

  const ArtistTopTracksSection({
    Key? key,
    required this.tracks,
    required this.onTrackTap,
    required this.onMoreOptionsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 24, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Text(
                'Popüler',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tracks.length > 5
                  ? 5
                  : tracks.length, // Sadece ilk 5 şarkıyı göster
              itemBuilder: (context, index) {
                final track = tracks[index];
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          track.imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    track.title,
                    style: TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Popüler • ${(index + 1) * 100000 + 500000} dinlenme',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white70),
                    onPressed: () => onMoreOptionsTap(track),
                  ),
                  onTap: () => onTrackTap(track),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
