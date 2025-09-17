class Album {
  final String id;
  final String name;
  final String artist;
  final String imageUrl;
  final int year;
  final List<String> songIds;

  Album({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
    required this.year,
    required this.songIds,
  });

  // JSON'dan Album nesnesi oluşturmak için factory metodu
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      artist: json['artists'] != null && (json['artists'] as List).isNotEmpty
          ? (json['artists'][0]['name'] ?? '')
          : '',
      imageUrl: json['images'] != null && (json['images'] as List).isNotEmpty
          ? json['images'][0]['url'] ?? ''
          : 'https://picsum.photos/id/40/200',
      year: json['release_date'] != null
          ? int.tryParse(json['release_date'].substring(0, 4)) ??
                DateTime.now().year
          : DateTime.now().year,
      songIds: [],
    );
  }
}
