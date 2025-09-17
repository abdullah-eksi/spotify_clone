import 'dart:math';
import '../model/playlist.dart';
import '../model/song.dart';
import 'mock_song_service.dart';

/// Çalma listelerini yöneten sınıf
class PlaylistManager {
  // Singleton pattern
  static final PlaylistManager _instance = PlaylistManager._internal();
  factory PlaylistManager() => _instance;
  PlaylistManager._internal();

  // Kullanıcının oluşturduğu çalma listeleri
  List<Playlist> _userPlaylists = [];

  // Şu an çalınan çalma listesi (varsa)
  Playlist? _currentPlaylist;
  int _currentSongIndex = 0;
  bool _shuffle = false;
  List<int>? _shuffleIndices;

  // Tekrar kullanılan yardımcı metot - playlist'i günceller
  Playlist _updatePlaylist(
    int index, {
    String? name,
    String? imageUrl,
    String? description,
    List<Song>? songs,
  }) {
    return Playlist(
      id: _userPlaylists[index].id,
      name: name ?? _userPlaylists[index].name,
      imageUrl: imageUrl ?? _userPlaylists[index].imageUrl,
      description: description ?? _userPlaylists[index].description,
      createdBy: _userPlaylists[index].createdBy,
      songs: songs ?? _userPlaylists[index].songs,
    );
  }

  // Çalma listesi örnekleri - gerçek uygulamada API'den gelecek
  List<Playlist> getUserPlaylists() {
    if (_userPlaylists.isEmpty) {
      _initializeDefaultPlaylists();
    }
    return _userPlaylists;
  }

  // Varsayılan çalma listeleri - API ile değiştirilecek
  void _initializeDefaultPlaylists() {
    if (_userPlaylists.isNotEmpty) return;

    // Örnek playlist oluştur - API'den gerçek veriler gelecek
    final allSongs = MockSongService.getSongs();

    _userPlaylists = [
      Playlist(
        id: 'user-1',
        name: 'Favori Şarkılarım',
        imageUrl: 'https://picsum.photos/id/30/200',
        createdBy: 'Siz',
        songs: allSongs.take(5).toList(),
      ),
      Playlist(
        id: 'user-2',
        name: 'Haftalık Keşifler',
        imageUrl: 'https://picsum.photos/id/31/200',
        description: 'Sizin için önerilen şarkılar',
        createdBy: 'Siz',
        songs: allSongs.skip(5).take(5).toList(),
      ),
    ];
  }

  // Yeni çalma listesi oluşturma
  Playlist createPlaylist({
    required String name,
    String description = '',
    String? imageUrl,
  }) {
    final id = 'user-${DateTime.now().millisecondsSinceEpoch}';

    final playlist = Playlist(
      id: id,
      name: name,
      imageUrl:
          imageUrl ?? 'https://picsum.photos/id/${Random().nextInt(100)}/200',
      description: description,
      createdBy: 'Siz',
      songs: [], // Başlangıçta boş
    );

    _userPlaylists.add(playlist);
    return playlist;
  }

  // Çalma listesine şarkı ekleme
  bool addSongToPlaylist(String playlistId, Song song) {
    final playlistIndex = _userPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex < 0) return false;

    // Şarkı zaten listede var mı kontrol et
    if (_userPlaylists[playlistIndex].songs.any((s) => s.id == song.id)) {
      return false;
    }

    // Yeni şarkı listesi oluştur
    final updatedSongs = List<Song>.from(_userPlaylists[playlistIndex].songs)
      ..add(song);

    // Playlist'i güncelle
    _userPlaylists[playlistIndex] = _updatePlaylist(
      playlistIndex,
      songs: updatedSongs,
    );

    return true;
  }

  // Çalma listesinden şarkı silme
  bool removeSongFromPlaylist(String playlistId, String songId) {
    final playlistIndex = _userPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex < 0) return false;

    final songIndex = _userPlaylists[playlistIndex].songs.indexWhere(
      (s) => s.id == songId,
    );
    if (songIndex < 0) return false;

    final updatedSongs = List<Song>.from(_userPlaylists[playlistIndex].songs)
      ..removeAt(songIndex);

    // Playlist'i güncelle
    _userPlaylists[playlistIndex] = _updatePlaylist(
      playlistIndex,
      songs: updatedSongs,
    );

    return true;
  }

  // Çalma listesi silme
  bool deletePlaylist(String playlistId) {
    final initialLength = _userPlaylists.length;
    _userPlaylists.removeWhere((p) => p.id == playlistId);
    return _userPlaylists.length < initialLength;
  }

  // Çalma listesi adı değiştirme
  bool renamePlaylist(String playlistId, String newName) {
    final playlistIndex = _userPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex < 0) return false;

    _userPlaylists[playlistIndex] = _updatePlaylist(
      playlistIndex,
      name: newName,
    );
    return true;
  }

  // Çalma listesi kapak fotoğrafını değiştirme
  bool updatePlaylistImage(String playlistId, String newImageUrl) {
    final playlistIndex = _userPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex < 0) return false;

    _userPlaylists[playlistIndex] = _updatePlaylist(
      playlistIndex,
      imageUrl: newImageUrl,
    );
    return true;
  }

  // Çalma listesi açıklamasını değiştirme
  bool updatePlaylistDescription(String playlistId, String newDescription) {
    final playlistIndex = _userPlaylists.indexWhere((p) => p.id == playlistId);
    if (playlistIndex < 0) return false;

    _userPlaylists[playlistIndex] = _updatePlaylist(
      playlistIndex,
      description: newDescription,
    );
    return true;
  }

  // PLAYBACK FUNCTIONS

  // Çalma listesini çalma
  Playlist? startPlaylist(
    String playlistId, {
    int startIndex = 0,
    bool shuffle = false,
  }) {
    final playlistIndex = MockSongService.getPlaylists().indexWhere(
      (p) => p.id == playlistId,
    );

    if (playlistIndex < 0) {
      // Kullanıcı playlistlerini kontrol et
      final userPlaylistIndex = _userPlaylists.indexWhere(
        (p) => p.id == playlistId,
      );
      if (userPlaylistIndex < 0) return null;

      _currentPlaylist = _userPlaylists[userPlaylistIndex];
    } else {
      _currentPlaylist = MockSongService.getPlaylists()[playlistIndex];
    }

    _shuffle = shuffle;
    if (_shuffle) {
      _createShuffleIndices();
      _currentSongIndex = 0; // Shuffle dizisinin ilk elemanı
    } else {
      _currentSongIndex = startIndex.clamp(
        0,
        _currentPlaylist!.songs.length - 1,
      );
    }

    return _currentPlaylist;
  }

  // Çalma listesi karıştırma modunu ayarlama
  void setShuffleMode(bool shuffleEnabled) {
    if (_shuffle == shuffleEnabled || _currentPlaylist == null) return;

    _shuffle = shuffleEnabled;

    if (_shuffle) {
      // Şu anki şarkıyı yakala
      final currentSong = getCurrentSong();

      // Karıştırma dizisi oluştur
      _createShuffleIndices();

      // Şu anki şarkıyı ilk pozisyona getir
      if (currentSong != null) {
        final actualIndex = _currentPlaylist!.songs.indexWhere(
          (s) => s.id == currentSong.id,
        );
        if (actualIndex >= 0) {
          final shufflePosition = _shuffleIndices!.indexOf(actualIndex);
          if (shufflePosition >= 0) {
            // Şu anki şarkının shuffle dizisindeki konumunu 0 ile değiştir
            final temp = _shuffleIndices![0];
            _shuffleIndices![0] = _shuffleIndices![shufflePosition];
            _shuffleIndices![shufflePosition] = temp;
            _currentSongIndex = 0;
          }
        }
      }
    } else {
      // Normal moda geçerken şu anki şarkının gerçek indexini kullan
      if (_shuffleIndices != null &&
          _currentSongIndex >= 0 &&
          _currentSongIndex < _shuffleIndices!.length) {
        _currentSongIndex = _shuffleIndices![_currentSongIndex];
      }
      _shuffleIndices = null;
    }
  }

  // Karıştırma dizisi oluştur
  void _createShuffleIndices() {
    if (_currentPlaylist == null) return;

    final songCount = _currentPlaylist!.songs.length;
    _shuffleIndices = List.generate(songCount, (i) => i);

    // Fisher-Yates karıştırma algoritması
    final random = Random();
    for (var i = songCount - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      // Swap
      final temp = _shuffleIndices![i];
      _shuffleIndices![i] = _shuffleIndices![j];
      _shuffleIndices![j] = temp;
    }
  }

  // Şu anki şarkıyı alma
  Song? getCurrentSong() {
    if (_currentPlaylist == null || _currentPlaylist!.songs.isEmpty)
      return null;

    final index = _getRealIndex(_currentSongIndex);
    if (index < 0 || index >= _currentPlaylist!.songs.length) return null;

    return _currentPlaylist!.songs[index];
  }

  // Sonraki şarkıya geçme
  Song? nextSong() {
    if (_currentPlaylist == null || _currentPlaylist!.songs.isEmpty)
      return null;

    _currentSongIndex++;

    final maxIndex = _shuffle
        ? _shuffleIndices!.length - 1
        : _currentPlaylist!.songs.length - 1;

    // Listenin sonuna gelindi
    if (_currentSongIndex > maxIndex) {
      _currentSongIndex = 0; // Listenin başına dön
    }

    return getCurrentSong();
  }

  // Önceki şarkıya geçme
  Song? previousSong() {
    if (_currentPlaylist == null || _currentPlaylist!.songs.isEmpty)
      return null;

    _currentSongIndex--;

    // Listenin başından geriye gidilirse
    if (_currentSongIndex < 0) {
      final maxIndex = _shuffle
          ? _shuffleIndices!.length - 1
          : _currentPlaylist!.songs.length - 1;
      _currentSongIndex = maxIndex; // Listenin sonuna git
    }

    return getCurrentSong();
  }

  // Gerçek şarkı indexini alma (karıştırma modunda farklı)
  int _getRealIndex(int index) {
    if (_shuffle && _shuffleIndices != null) {
      if (index >= 0 && index < _shuffleIndices!.length) {
        return _shuffleIndices![index];
      }
      return -1;
    }
    return index;
  }

  // Çalma listesi bittiğinde çalacak rastgele şarkıyı seçme
  Song getRandomSongAfterPlaylistEnds() {
    final allSongs = MockSongService.getSongs();
    final randomIndex = Random().nextInt(allSongs.length);
    return allSongs[randomIndex];
  }

  // Shuffle modunu kontrol et
  bool isShuffleMode() {
    return _shuffle;
  }
}
