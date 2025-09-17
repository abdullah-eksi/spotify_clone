import 'package:flutter/material.dart';
import '../../../model/artist.dart';

class ArtistDetailHeader extends StatelessWidget {
  final Artist artist;
  final bool isFollowing;
  final VoidCallback onFollowTap;
  final String formattedListenerCount;

  const ArtistDetailHeader({
    Key? key,
    required this.artist,
    required this.isFollowing,
    required this.onFollowTap,
    required this.formattedListenerCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340.0,
      pinned: true,
      backgroundColor: Colors.black.withOpacity(0.85),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          artist.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Artist cover image
            Image.network(artist.imageUrl, fit: BoxFit.cover),
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                  stops: [0.4, 0.65, 0.8, 1.0],
                ),
              ),
            ),
            // Monthly listeners label
            Positioned(
              bottom: 70,
              left: 16,
              child: Text(
                'Aylık dinleyici: $formattedListenerCount',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            // Follow button
            Positioned(
              bottom: 16,
              left: 16,
              child: OutlinedButton(
                onPressed: onFollowTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isFollowing ? Color(0xFF1DB954) : Colors.white,
                    width: 1.5,
                  ),
                  backgroundColor: isFollowing
                      ? Color(0xFF1DB954).withOpacity(0.2)
                      : Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  isFollowing ? 'Takip ediliyor' : 'Takip et',
                  style: TextStyle(
                    color: isFollowing ? Color(0xFF1DB954) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
