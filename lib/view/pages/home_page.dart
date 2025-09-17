import 'package:flutter/material.dart';
import '../../model/playlist.dart';
import '../../model/artist.dart';
import '../../model/song.dart';
import 'player_page.dart';
import 'package:spoclon/view/component/component.dart';
import 'process/home_process.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final songs = HomeProcess.getAllSongs();
    final playlists = HomeProcess.getPopularPlaylists();
    final artists = HomeProcess.getPopularArtists();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HomeAppBar(
          onNotificationsTap: () {
            // Bildirimler
          },
          onHistoryTap: () {
            // Geçmiş
          },
          onSettingsTap: () {
            // Ayarlar
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0xFF1DB954).withOpacity(0.3), Colors.black],
          ),
        ),
        child: ListView(
          children: [
            // Recent Playlists Grid
            RecentPlaylistGrid(
              playlists: playlists,
              onPlaylistTap: (playlist) {
                Navigator.pushNamed(
                  context,
                  '/playlist_detail',
                  arguments: playlist,
                );
              },
            ),

            // Made For You Section
            SectionHeader(
              title: 'Senin İçin Hazırlandı',
              onSeeAllTap: () {
                Navigator.pushNamed(context, '/playlists');
              },
            ),

            // Playlists Horizontal Scroll
            ScrollableItemList<Playlist>(
              items: playlists,
              itemBuilder: (context, index) {
                return PlaylistCard(playlist: playlists[index]);
              },
            ),

            // Recently Played Section
            SectionHeader(
              title: 'Daha Önce Çalınanlar',
              onSeeAllTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Son çalınanlar sayfası (yapım aşamasında)'),
                  ),
                );
              },
            ),

            // Recently Played Songs
            ScrollableItemList<Song>(
              items: songs,
              itemBuilder: (context, index) {
                final song = songs[index];
                return SongItemCard(
                  song: song,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerPage(song: song),
                      ),
                    );
                  },
                );
              },
            ),

            // Popular Artists Section
            SectionHeader(
              title: 'Sanatçılar',
              onSeeAllTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sanatçılar sayfası (yapım aşamasında)'),
                  ),
                );
              },
            ),

            // Artists Horizontal Scroll
            ScrollableItemList<Artist>(
              items: artists,
              itemBuilder: (context, index) {
                final artist = artists[index];
                return HomeArtistCard(
                  artist: artist,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/artist_detail',
                      arguments: artist,
                    );
                  },
                );
              },
            ),
            SizedBox(height: 76),
          ],
        ),
      ),
    );
  }
}
