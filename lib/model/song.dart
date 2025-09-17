class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final String audioUrl;
  final int durationMs;
  final String genre;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.audioUrl,
    this.durationMs = 0,
    this.genre = '',
  });

  // JSON'dan Song nesnesi oluşturmak için factory metodu
  factory Song.fromJson(Map<String, dynamic> json) {
    // Spotify API'den gelen verileri işlemek için
    return Song(
      id: json['id'] ?? '',
      title: json['name'] ?? '',
      // API'den gelen sanatçı bilgisi bir dizi olabilir
      artist: json['artists'] != null && (json['artists'] as List).isNotEmpty
          ? (json['artists'] as List).map((a) => a['name']).join(', ')
          : '',
      album: json['album'] != null ? json['album']['name'] ?? '' : '',
      imageUrl:
          json['album'] != null &&
              json['album']['images'] != null &&
              (json['album']['images'] as List).isNotEmpty
          ? json['album']['images'][0]['url'] ?? ''
          : 'https://picsum.photos/id/1/200', // Varsayılan resim
      audioUrl: json['preview_url'] ?? '',
      durationMs: json['duration_ms'] ?? 0,
      genre: json['genre'] ?? '',
    );
  }
}
