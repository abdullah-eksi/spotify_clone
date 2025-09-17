import 'package:flutter/material.dart';
import '../../../model/category.dart';
import '../../../model/song.dart';
import '../../../model/album.dart';
import '../../../model/artist.dart';
import '../../../model/playlist.dart';
import '../../../service/mock_song_service.dart';
import '../player_page.dart';
import '../album_page.dart';

class SearchProcess {
  // Arama yapma metodu
  static void performSearch({
    required String query,
    required String selectedSearchType,
    required Function(
      List<Song>,
      List<Album>,
      List<Artist>,
      List<Playlist>,
      String,
      bool,
    )
    onSearchCompleted,
    required List<String> searchHistory,
    required Function(List<String>) onHistoryUpdated,
  }) {
    if (query.isEmpty) {
      onSearchCompleted([], [], [], [], '', false);
      return;
    }

    // Arama geçmişine ekle (eğer yoksa)
    if (!searchHistory.contains(query) && query.isNotEmpty) {
      final newHistory = List<String>.from(searchHistory);
      newHistory.insert(0, query);
      // En fazla 10 arama geçmişi tutuyoruz
      if (newHistory.length > 10) {
        newHistory.removeLast();
      }
      onHistoryUpdated(newHistory);
    }

    // Mock verilerle arama yapıyoruz
    // Gerçek bir uygulamada burada API çağrısı olabilir
    List<Song> songResults = [];
    List<Album> albumResults = [];
    List<Artist> artistResults = [];
    List<Playlist> playlistResults = [];

    // Arama tipine göre arama yap
    if (selectedSearchType == 'Tümü' || selectedSearchType == 'Şarkılar') {
      songResults = MockSongService.getSongs()
          .where(
            (song) =>
                song.title.toLowerCase().contains(query.toLowerCase()) ||
                song.artist.toLowerCase().contains(query.toLowerCase()) ||
                song.album.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    if (selectedSearchType == 'Tümü' || selectedSearchType == 'Albümler') {
      albumResults = MockSongService.getAlbums()
          .where(
            (album) =>
                album.name.toLowerCase().contains(query.toLowerCase()) ||
                album.artist.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    if (selectedSearchType == 'Tümü' || selectedSearchType == 'Sanatçılar') {
      artistResults = MockSongService.getArtists()
          .where(
            (artist) => artist.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    if (selectedSearchType == 'Tümü' ||
        selectedSearchType == 'Çalma Listeleri') {
      playlistResults = MockSongService.getPlaylists()
          .where(
            (playlist) =>
                playlist.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    onSearchCompleted(
      songResults,
      albumResults,
      artistResults,
      playlistResults,
      query,
      false,
    );
  }

  // Gezinme içeriğini oluşturan metod
  static Widget buildBrowseContent(
    List<Category> categories,
    Function(String) onCategorySelected,
    Function(String) onArtistSelected,
  ) {
    return ListView(
      padding: EdgeInsets.only(
        bottom: 8,
      ), // Add bottom padding to prevent overflow
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'Tüm Kategoriler',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Kategoriler Grid'i
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  // Kategori seçildiğinde
                  onCategorySelected(category.name);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: category.color,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Popüler Sanatçılar
        Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            'Popüler Sanatçılar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Container(
          height: 155, // Increased height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: MockSongService.getArtists().length > 10
                ? 10
                : MockSongService.getArtists().length,
            itemBuilder: (context, index) {
              final artist = MockSongService.getArtists()[index];
              return GestureDetector(
                onTap: () {
                  onArtistSelected(artist.name);
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.network(
                          artist.imageUrl,
                          height: 100,
                          width: 100,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 24),
      ],
    );
  }

  // Arama geçmişini gösteren metod
  static Widget buildSearchHistory(
    List<String> searchHistory,
    Function(String) onHistoryItemSelected,
    Function(String) onHistoryItemRemoved,
  ) {
    return ListView(
      padding: EdgeInsets.only(
        bottom: 8,
      ), // Add bottom padding to prevent overflow
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'Arama Geçmişi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ...(searchHistory.isEmpty
            ? [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Text(
                      'Arama geçmişi bulunamadı',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ]
            : searchHistory.map((item) {
                return ListTile(
                  leading: Icon(Icons.history, color: Colors.grey),
                  title: Text(item, style: TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey, size: 18),
                    onPressed: () => onHistoryItemRemoved(item),
                  ),
                  onTap: () => onHistoryItemSelected(item),
                );
              }).toList()),
      ],
    );
  }

  // Arama sonuçlarını gösteren metod
  static Widget buildSearchResults({
    required List<Song> songResults,
    required List<Album> albumResults,
    required List<Artist> artistResults,
    required List<Playlist> playlistResults,
    required bool isSearching,
    required BuildContext context,
  }) {
    final bool hasNoResults =
        songResults.isEmpty &&
        albumResults.isEmpty &&
        artistResults.isEmpty &&
        playlistResults.isEmpty;

    if (isSearching) {
      return Center(child: CircularProgressIndicator());
    }

    if (hasNoResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Sonuç bulunamadı',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Farklı bir arama yapmayı deneyin',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.only(
        bottom: 8,
      ), // Add bottom padding to prevent overflow
      children: [
        // Sanatçı Sonuçları
        if (artistResults.isNotEmpty) ...[
          buildSectionHeader('Sanatçılar'),
          Container(
            height: 155, // Increased height to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: artistResults.length,
              itemBuilder: (context, index) {
                final artist = artistResults[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/artist_detail',
                      arguments: artist,
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            artist.imageUrl,
                            height: 100,
                            width: 100,
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
                          maxLines: 2,
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

        // Çalma Listesi Sonuçları
        if (playlistResults.isNotEmpty) ...[
          buildSectionHeader('Çalma Listeleri'),
          Container(
            height: 185, // Increased height to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: playlistResults.length,
              itemBuilder: (context, index) {
                final playlist = playlistResults[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/playlist_detail',
                      arguments: playlist,
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            playlist.imageUrl,
                            height: 140,
                            width: 140,
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

        // Albüm Sonuçları
        if (albumResults.isNotEmpty) ...[
          buildSectionHeader('Albümler'),
          Container(
            height: 185, // Increased height to prevent overflow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: albumResults.length,
              itemBuilder: (context, index) {
                final album = albumResults[index];
                return GestureDetector(
                  onTap: () {
                    // Albüm detay sayfasına git
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumPage(album: album),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            album.imageUrl,
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          album.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          album.artist,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
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

        // Şarkı Sonuçları
        if (songResults.isNotEmpty) ...[
          buildSectionHeader('Şarkılar'),
          ...(songResults.map((song) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  song.imageUrl,
                  width: 48,
                  height: 48,
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
          }).toList()),
        ],

        SizedBox(height: 24),
      ],
    );
  }

  // Bölüm başlıkları için yardımcı metod
  static Widget buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
