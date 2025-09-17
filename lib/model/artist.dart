import 'song.dart';

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String bio;
  final List<Song> songs;
  final int followers;
  final List<String> genres;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.bio = '',
    required this.songs,
    this.followers = 0,
    this.genres = const [],
  });

  // JSON'dan Artist nesnesi oluşturmak için factory metodu
  factory Artist.fromJson(
    Map<String, dynamic> json, {
    List<Song> songs = const [],
  }) {
    // Spotify API'den gelen verileri işlemek için
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['images'] != null && (json['images'] as List).isNotEmpty
          ? json['images'][0]['url'] ?? ''
          : 'https://picsum.photos/id/20/200', // Varsayılan resim
      bio: '', // API'den bio bilgisini ayrıca almak gerekecek
      songs: songs,
      followers: json['followers'] != null
          ? json['followers']['total'] ?? 0
          : 0,
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
    );
  }
}
