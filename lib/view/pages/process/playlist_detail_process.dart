import 'package:flutter/material.dart';
import '../../../model/playlist.dart';
import '../../../model/song.dart';
import '../../../service/favorite_service.dart';
import '../../../service/playlist_manager.dart';
import '../player_page.dart';

class PlaylistDetailProcess {
  // Toplam süreyi hesapla
  static String calculateTotalDuration(List<Song> songs) {
    final totalDuration = songs.length * 3; // Ortalama 3 dakika varsayalım
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    return hours > 0
        ? '$hours saat ${minutes > 0 ? '$minutes dk' : ''}'
        : '$minutes dk';
  }

  // Şarkıyı çal
  static void playSong(
    BuildContext context,
    Playlist playlist,
    Song song,
    int index,
  ) {
    final playlistManager = PlaylistManager();

    // Playlist'i başlat ve belirtilen şarkıdan çalmaya başla
    playlistManager.startPlaylist(playlist.id, startIndex: index);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerPage(song: song)),
    );
  }

  // Tüm şarkıları çal
  static void playAll(
    BuildContext context,
    Playlist playlist, {
    bool shuffle = false,
  }) {
    if (playlist.songs.isEmpty) return;

    final playlistManager = PlaylistManager();

    playlistManager.startPlaylist(playlist.id, startIndex: 0, shuffle: shuffle);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerPage(
          song: shuffle ? playlistManager.getCurrentSong() : playlist.songs[0],
        ),
      ),
    );
  }

  // Favori kontrolü - şarkı
  static bool isSongFavorite(String songId) {
    return FavoriteService.isSongFavorite(songId);
  }

  // Favori durumunu değiştir - şarkı
  static bool toggleSongFavorite(String songId) {
    FavoriteService.toggleSongFavorite(songId);
    return FavoriteService.isSongFavorite(songId);
  }

  // Favori kontrolü - çalma listesi
  static bool isPlaylistFavorite(String playlistId) {
    return FavoriteService.isPlaylistFavorite(playlistId);
  }

  // Favori durumunu değiştir - çalma listesi
  static bool togglePlaylistFavorite(String playlistId) {
    FavoriteService.togglePlaylistFavorite(playlistId);
    return FavoriteService.isPlaylistFavorite(playlistId);
  }

  // Çalma listesinden şarkı silme
  static bool removeSongFromPlaylist(String playlistId, String songId) {
    final playlistManager = PlaylistManager();
    return playlistManager.removeSongFromPlaylist(playlistId, songId);
  }

  // Şarkı öğesini oluştur
  static Widget buildSongItem({
    required Song song,
    required int index,
    required VoidCallback onTap,
    required VoidCallback onFavoriteToggle,
    required VoidCallback onOptionsPressed,
    required bool isFavorite,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${index + 1}', style: TextStyle(color: Colors.grey)),
          SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              song.imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      title: Text(
        song.title,
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Color(0xFF1DB954) : Colors.grey,
            ),
            onPressed: onFavoriteToggle,
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey),
            onPressed: onOptionsPressed,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
