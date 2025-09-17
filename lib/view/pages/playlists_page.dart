import 'package:flutter/material.dart';
import '../../model/playlist.dart';
import '../../service/playlist_manager.dart';
import '../../service/favorite_service.dart';
import '../pages/playlist_detail_page.dart';

class PlaylistsPage extends StatefulWidget {
  @override
  _PlaylistsPageState createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  late PlaylistManager _playlistManager;

  @override
  void initState() {
    super.initState();
    _playlistManager = PlaylistManager();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaylists = _playlistManager.getUserPlaylists();
    final favoritePlaylists = FavoriteService.getFavoritePlaylists();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Çalma Listeleri',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToCreatePlaylist(context),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (favoritePlaylists.isNotEmpty) ...[
            _buildSectionHeader('Beğenilen Çalma Listeleri'),
            _buildPlaylistGrid(favoritePlaylists),
            SizedBox(height: 24),
          ],

          _buildSectionHeader('Çalma Listelerim'),
          if (userPlaylists.isNotEmpty)
            _buildPlaylistGrid(userPlaylists)
          else
            _buildEmptyState(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreatePlaylist(context),
        backgroundColor: Color(0xFF1DB954),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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

  Widget _buildPlaylistGrid(List<Playlist> playlists) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return _buildPlaylistCard(playlist);
      },
    );
  }

  Widget _buildPlaylistCard(Playlist playlist) {
    return GestureDetector(
      onTap: () => _navigateToPlaylistDetail(context, playlist),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF282828),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Playlist cover image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(playlist.imageUrl, fit: BoxFit.cover),
              ),
            ),

            // Playlist info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${playlist.songs.length} şarkı',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_add, size: 72, color: Colors.white54),
          SizedBox(height: 16),
          Text(
            'Henüz bir çalma listeniz yok',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Müziklerinizi organize etmek için\nyeni bir çalma listesi oluşturun',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _navigateToCreatePlaylist(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1DB954),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text('Çalma Listesi Oluştur'),
          ),
        ],
      ),
    );
  }

  void _navigateToCreatePlaylist(BuildContext context) {
    Navigator.pushNamed(context, '/create_playlist').then((_) {
      // Sayfaya geri dönüldüğünde listeyi güncelle
      setState(() {});
    });
  }

  void _navigateToPlaylistDetail(BuildContext context, Playlist playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistDetailPage(playlist: playlist),
      ),
    ).then((_) {
      // Sayfaya geri dönüldüğünde listeyi güncelle
      setState(() {});
    });
  }
}
