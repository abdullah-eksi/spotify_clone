import '../model/song.dart';
import '../model/artist.dart';
import '../model/playlist.dart';
import 'mock_song_service.dart';

/// API servis sınıfı - API hizmetlerini simüle eder
class ApiService {
  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // API gecikme simülasyonu için yardımcı fonksiyon
  Future<T> _simulateApiCall<T>(T Function() dataProvider) async {
    await Future.delayed(Duration(milliseconds: 300));
    return dataProvider();
  }

  /// Şarkıları alacak metot
  Future<List<Song>> getSongs() async {
    return _simulateApiCall(() => MockSongService.getSongs());
  }

  /// Sanatçıları alacak metot
  Future<List<Artist>> getArtists() async {
    return _simulateApiCall(() => MockSongService.getArtists());
  }

  /// Çalma listelerini alacak metot
  Future<List<Playlist>> getPlaylists() async {
    return _simulateApiCall(() => MockSongService.getPlaylists());
  }

  /// Bir sanatçının şarkılarını alacak metot
  Future<List<Song>> getSongsByArtist(String artistName) async {
    return _simulateApiCall(
      () => MockSongService.getSongs()
          .where((song) => song.artist == artistName)
          .toList(),
    );
  }

  /// Bir albümün şarkılarını alacak metot
  Future<List<Song>> getSongsByAlbum(String albumName) async {
    return _simulateApiCall(
      () => MockSongService.getSongs()
          .where((song) => song.album == albumName)
          .toList(),
    );
  }
}
