import 'song.dart';

class Playlist {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String createdBy;
  final List<Song> songs;
  final bool isPublic;

  Playlist({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description = '',
    required this.createdBy,
    required this.songs,
    this.isPublic = true,
  });

  // JSON'dan Playlist nesnesi oluşturmak için factory metodu
  factory Playlist.fromJson(
    Map<String, dynamic> json, {
    List<Song> songs = const [],
  }) {
    // Spotify API'den gelen verileri işlemek için
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['images'] != null && (json['images'] as List).isNotEmpty
          ? json['images'][0]['url'] ?? ''
          : 'https://picsum.photos/id/10/200', // Varsayılan resim
      description: json['description'] ?? '',
      createdBy: json['owner'] != null
          ? json['owner']['display_name'] ?? 'Spotify'
          : 'Spotify',
      songs: songs,
      isPublic: json['public'] ?? true,
    );
  }

  // Çalma listesinin şarkılarını güncellemek için yardımcı metot
  Playlist copyWithSongs(List<Song> newSongs) {
    return Playlist(
      id: this.id,
      name: this.name,
      imageUrl: this.imageUrl,
      description: this.description,
      createdBy: this.createdBy,
      songs: newSongs,
      isPublic: this.isPublic,
    );
  }
}
