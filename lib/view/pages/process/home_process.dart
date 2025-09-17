import 'package:flutter/material.dart';
import '../../../service/mock_song_service.dart';
import '../../../model/playlist.dart';
import '../../../model/artist.dart';
import '../../../model/song.dart';
import '../player_page.dart';

class HomeProcess {
  // Getir popüler playlists (4 adet rastgele)
  static List<Playlist> getPopularPlaylists() {
    final allPlaylists = MockSongService.getPlaylists();

    // Eğer çalma listesi sayısı 4 veya daha az ise
    if (allPlaylists.length <= 6) {
      return allPlaylists;
    }

    // Rastgele 4 çalma listesi seç
    allPlaylists.shuffle();
    return allPlaylists.take(6).toList();
  }

  // Getir popüler sanatçılar
  static List<Artist> getPopularArtists() {
    return MockSongService.getArtists();
  }

  // Getir tüm şarkılar
  static List<Song> getAllSongs() {
    return MockSongService.getSongs();
  }

  // Şarkıları çalma listesine göre filtrele
  static List<Song> getSongsFromPlaylist(Playlist playlist) {
    return MockSongService.getSongs()
        .where((song) => playlist.songs.map((s) => s.id).contains(song.id))
        .toList();
  }

  // Önerilen şarkıları getir
  static List<Song> getRecommendedSongs() {
    // Burada gerçek bir uygulamada kullanıcı dinleme geçmişine göre öneriler yapılabilir
    // Şimdilik rastgele seçiyoruz
    final allSongs = MockSongService.getSongs();
    allSongs.shuffle();
    return allSongs.take(10).toList();
  }

  // Yeni çıkan albümleri getir
  static List<dynamic> getNewReleases() {
    final albums = MockSongService.getAlbums();
    albums.sort((a, b) => b.year.compareTo(a.year));
    return albums.take(6).toList();
  }

  // Popüler çalma listelerini getir
  static Widget buildPopularPlaylists(
    List<Playlist> playlists,
    Function(Playlist) onPlaylistTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Popüler Çalma Listeleri',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return GestureDetector(
                onTap: () => onPlaylistTap(playlist),
                child: Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          playlist.imageUrl,
                          height: 160,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        playlist.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Popüler sanatçıları getir
  static Widget buildPopularArtists(
    List<Artist> artists,
    Function(Artist) onArtistTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Popüler Sanatçılar',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              return GestureDetector(
                onTap: () => onArtistTap(artist),
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.network(
                          artist.imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        artist.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Önerilen şarkıları getir
  static Widget buildRecommendedSongs(List<Song> songs, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Senin İçin Seçtiklerimiz',
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
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: songs.length > 5 ? 5 : songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  song.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                song.title,
                style: TextStyle(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${song.artist} • ${song.album}',
                style: TextStyle(color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
      ],
    );
  }
}
