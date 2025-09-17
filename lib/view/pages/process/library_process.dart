import 'package:flutter/material.dart';
import '../../../model/artist.dart';
import '../../../model/playlist.dart';
import '../../../model/album.dart';
import '../../../service/mock_song_service.dart';
import '../../../service/sort_service.dart';
import '../album_page.dart';

class LibraryProcess {
  // Sıralanmış çalma listelerini getir
  static List<Playlist> getSortedPlaylists(String sortOrder) {
    SortOrder order;
    try {
      order = SortOrder.values.firstWhere(
        (e) => e.toString().split('.').last == sortOrder,
        orElse: () => SortOrder.alphabetical,
      );
    } catch (_) {
      order = SortOrder.alphabetical;
    }

    return SortService.sortPlaylists(MockSongService.getPlaylists(), order);
  }

  // Sıralanmış sanatçıları getir
  static List<Artist> getSortedArtists(String sortOrder) {
    SortOrder order;
    try {
      order = SortOrder.values.firstWhere(
        (e) => e.toString().split('.').last == sortOrder,
        orElse: () => SortOrder.alphabetical,
      );
    } catch (_) {
      order = SortOrder.alphabetical;
    }

    switch (order) {
      case SortOrder.alphabetical:
        return List.from(MockSongService.getArtists())
          ..sort((a, b) => a.name.compareTo(b.name));
      default:
        return MockSongService.getArtists();
    }
  }

  // Sıralanmış albümleri getir
  static List<Album> getSortedAlbums(String sortOrder) {
    SortOrder order;
    try {
      order = SortOrder.values.firstWhere(
        (e) => e.toString().split('.').last == sortOrder,
        orElse: () => SortOrder.alphabetical,
      );
    } catch (_) {
      order = SortOrder.alphabetical;
    }

    switch (order) {
      case SortOrder.alphabetical:
        return List.from(MockSongService.getAlbums())
          ..sort((a, b) => a.name.compareTo(b.name));
      case SortOrder.creator:
        return List.from(MockSongService.getAlbums())
          ..sort((a, b) => a.artist.compareTo(b.artist));
      default:
        return MockSongService.getAlbums();
    }
  }

  // Albüm görünümünü oluştur
  static Widget buildAlbumsView(
    List<Album> albums,
    bool isGridView,
    BuildContext context,
  ) {
    if (isGridView) {
      return GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlbumPage(album: album),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      album.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
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
                SizedBox(height: 2),
                Text(
                  album.artist,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                album.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              album.name,
              style: TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              album.artist,
              style: TextStyle(color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlbumPage(album: album),
                ),
              );
            },
          );
        },
      );
    }
  }

  // Sanatçı görünümünü oluştur
  static Widget buildArtistsView(
    List<Artist> artists,
    bool isGridView,
    BuildContext context,
  ) {
    if (isGridView) {
      return GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/artist_detail', arguments: artist);
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipOval(
                    child: Image.network(artist.imageUrl, fit: BoxFit.cover),
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
          );
        },
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return ListTile(
            leading: ClipOval(
              child: Image.network(
                artist.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              artist.name,
              style: TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/artist_detail', arguments: artist);
            },
          );
        },
      );
    }
  }

  // Çalma listeleri görünümünü oluştur
  static Widget buildPlaylistsView(
    List<Playlist> playlists,
    bool isGridView,
    BuildContext context,
  ) {
    if (isGridView) {
      return GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: playlists.length + 1, // +1 for the "Create Playlist" item
        itemBuilder: (context, index) {
          if (index == 0) {
            // Create Playlist Item
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/create_playlist');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Yeni Çalma Listesi Oluştur',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final playlist = playlists[index - 1];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/playlist_detail',
                arguments: playlist,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      playlist.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
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
          );
        },
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: playlists.length + 1, // +1 for the "Create Playlist" item
        itemBuilder: (context, index) {
          if (index == 0) {
            // Create Playlist Item
            return ListTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: Text(
                'Yeni Çalma Listesi Oluştur',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/create_playlist');
              },
            );
          }

          final playlist = playlists[index - 1];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                playlist.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              playlist.name,
              style: TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/playlist_detail',
                arguments: playlist,
              );
            },
          );
        },
      );
    }
  }

  // İndirilen içerikleri göster
  static Widget buildDownloadsView(bool isGridView) {
    // Burada indirilen içerikler gösterilecek
    // Şimdilik mock bir mesaj gösteriyoruz
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download_done, color: Colors.grey, size: 64),
          SizedBox(height: 16),
          Text(
            'İndirilen İçerik Yok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'İçerikleri indirerek çevrimdışı dinleyebilirsin',
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
