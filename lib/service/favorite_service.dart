import '../model/song.dart';
import '../model/playlist.dart';
import '../model/artist.dart';
import 'mock_song_service.dart';
import 'playlist_manager.dart';

/// Favori içerikleri yöneten servis
class FavoriteService {
  static final List<String> _favoriteSongIds = [];
  static final List<String> _favoritePlaylistIds = [];
  static final List<String> _favoriteArtistIds = [];

  // Generic toggle method for any favorite type
  static bool _toggleFavorite(String id, List<String> favoritesList) {
    if (favoritesList.contains(id)) {
      favoritesList.remove(id);
      return false;
    } else {
      favoritesList.add(id);
      return true;
    }
  }

  // Song methods
  static List<Song> getFavoriteSongs() {
    final songs = MockSongService.getSongs();
    return songs.where((song) => _favoriteSongIds.contains(song.id)).toList();
  }

  static bool isSongFavorite(String songId) {
    return _favoriteSongIds.contains(songId);
  }

  static bool toggleSongFavorite(String songId) {
    return _toggleFavorite(songId, _favoriteSongIds);
  }

  // Eski API uyumluluğu için metodlar
  static void addSongToFavorites(String songId) {
    if (!_favoriteSongIds.contains(songId)) {
      _favoriteSongIds.add(songId);
    }
  }

  static void removeSongFromFavorites(String songId) {
    _favoriteSongIds.remove(songId);
  }

  // Playlist methods
  static List<Playlist> getFavoritePlaylists() {
    // Spotify'ın önerdiği çalma listeleri
    final spotifyPlaylists = MockSongService.getPlaylists()
        .where((playlist) => _favoritePlaylistIds.contains(playlist.id))
        .toList();

    // Kullanıcının oluşturduğu çalma listeleri
    final userPlaylists = PlaylistManager()
        .getUserPlaylists()
        .where((playlist) => _favoritePlaylistIds.contains(playlist.id))
        .toList();

    // İki listeyi birleştir
    return [...spotifyPlaylists, ...userPlaylists];
  }

  static bool isPlaylistFavorite(String playlistId) {
    return _favoritePlaylistIds.contains(playlistId);
  }

  static bool togglePlaylistFavorite(String playlistId) {
    return _toggleFavorite(playlistId, _favoritePlaylistIds);
  }

  // Artist methods
  static List<Artist> getFavoriteArtists() {
    final artists = MockSongService.getArtists();
    return artists
        .where((artist) => _favoriteArtistIds.contains(artist.id))
        .toList();
  }

  static bool isArtistFavorite(String artistId) {
    return _favoriteArtistIds.contains(artistId);
  }

  static bool toggleArtistFavorite(String artistId) {
    return _toggleFavorite(artistId, _favoriteArtistIds);
  }
}
