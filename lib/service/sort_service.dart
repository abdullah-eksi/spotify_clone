import '../model/song.dart';
import '../model/playlist.dart';
import '../model/artist.dart';

enum SortOrder {
  recentlyPlayed,
  recentlyAdded,
  alphabetical,
  creator,
  mostPlayed,
}

/// Sıralama işlemlerini yöneten servis sınıfı
class SortService {
  /// Generic sıralama fonksiyonu
  static List<T> _sort<T>(
    List<T> items,
    SortOrder sortOrder,
    String Function(T) nameGetter,
    String Function(T)? creatorGetter,
  ) {
    switch (sortOrder) {
      case SortOrder.alphabetical:
        return List.from(items)
          ..sort((a, b) => nameGetter(a).compareTo(nameGetter(b)));
      case SortOrder.creator:
        if (creatorGetter != null) {
          return List.from(items)
            ..sort((a, b) => creatorGetter(a).compareTo(creatorGetter(b)));
        }
        return items;
      case SortOrder.recentlyAdded:
        // Gerçek uygulamada timestamp kullanılacak
        return List.from(items.reversed);
      case SortOrder.recentlyPlayed:
      case SortOrder.mostPlayed:
        // Gerçek uygulamada son çalma zamanı veya çalma sayısı kullanılacak
        return items;
    }
  }

  /// Çalma listelerini sırala
  static List<Playlist> sortPlaylists(
    List<Playlist> playlists,
    SortOrder sortOrder,
  ) {
    return _sort<Playlist>(
      playlists,
      sortOrder,
      (playlist) => playlist.name,
      (playlist) => playlist.createdBy,
    );
  }

  /// Şarkıları sırala
  static List<Song> sortSongs(List<Song> songs, SortOrder sortOrder) {
    return _sort<Song>(
      songs,
      sortOrder,
      (song) => song.title,
      (song) => song.artist,
    );
  }

  /// Sanatçıları sırala
  static List<Artist> sortArtists(List<Artist> artists, SortOrder sortOrder) {
    return _sort<Artist>(artists, sortOrder, (artist) => artist.name, null);
  }

  /// String sıralama tipini enum'a dönüştür
  static SortOrder sortOrderFromString(String sortOrderString) {
    switch (sortOrderString) {
      case 'Son Çalınanlar':
        return SortOrder.recentlyPlayed;
      case 'Son Eklenenler':
        return SortOrder.recentlyAdded;
      case 'Alfabetik':
        return SortOrder.alphabetical;
      case 'Oluşturan':
        return SortOrder.creator;
      case 'En Çok Çalınanlar':
        return SortOrder.mostPlayed;
      default:
        return SortOrder.recentlyPlayed;
    }
  }
}
