import 'package:flutter/material.dart';
import '../../model/artist.dart';
import '../../model/playlist.dart';
import '../../service/favorite_service.dart';
import 'package:spoclon/view/component/component.dart';
import 'process/library_process.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String _selectedFilter = 'Çalma Listeleri';
  bool _isGridView = false;
  final List<String> _filters = [
    'Çalma Listeleri',
    'Sanatçılar',
    'Albümler',
    'İndirilenler',
  ];
  String _sortOrder = 'Son Çalınanlar';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playlists = LibraryProcess.getSortedPlaylists(_sortOrder);
    final artists = LibraryProcess.getSortedArtists(_sortOrder);

    // Filter content based on selected filter
    Widget _buildContent() {
      switch (_selectedFilter) {
        case 'Çalma Listeleri':
          return _buildPlaylistsView(playlists);
        case 'Sanatçılar':
          return _buildArtistsView(artists);
        case 'Albümler':
          return _buildAlbumsView();
        case 'İndirilenler':
          return _buildDownloadedView();
        default:
          return _buildPlaylistsView(playlists);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar with user avatar and title
            LibraryAppBar(
              onSearchTap: () {
                // Show search
              },
              onAddTap: () {
                // Yeni çalma listesi oluştur
                _showAddPlaylistDialog();
              },
            ),

            // Filter chips row
            LibraryFilterBar(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterSelected: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),

            // Sorting and view options
            LibrarySortBar(
              sortOrder: _sortOrder,
              isGridView: _isGridView,
              onSortTap: _showSortingDialog,
              onViewToggle: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),

            // Main content area
            Expanded(child: _buildContent()),
            SizedBox(height: 60), // Space for mini player
          ],
        ),
      ),
    );
  }

  // Building different views
  Widget _buildPlaylistsView(List<Playlist> playlists) {
    if (_isGridView) {
      return GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return GridPlaylistCard(
            playlist: playlist,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/playlist_detail',
                arguments: playlist,
              );
            },
            onLongPress: () {
              _showPlaylistOptions(playlist);
            },
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return ListPlaylistCard(
            playlist: playlist,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/playlist_detail',
                arguments: playlist,
              );
            },
            onLongPress: () {
              _showPlaylistOptions(playlist);
            },
          );
        },
      );
    }
  }

  Widget _buildArtistsView(List<Artist> artists) {
    if (_isGridView) {
      return GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return GridArtistCard(
            artist: artist,
            onTap: () {
              Navigator.pushNamed(context, '/artist_detail', arguments: artist);
            },
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return ArtistListItem(
            artist: artist,
            onTap: () {
              Navigator.pushNamed(context, '/artist_detail', arguments: artist);
            },
          );
        },
      );
    }
  }

  Widget _buildAlbumsView() {
    final albums = LibraryProcess.getSortedAlbums(_sortOrder);

    if (_isGridView) {
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
              Navigator.pushNamed(context, '/album_detail', arguments: album);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    album.imageUrl,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  album.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  album.artist,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/album_detail', arguments: album);
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                album.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(album.name, style: TextStyle(color: Colors.white)),
            subtitle: Text(album.artist, style: TextStyle(color: Colors.grey)),
            trailing: Icon(Icons.more_vert, color: Colors.grey),
          );
        },
      );
    }
  }

  Widget _buildDownloadedView() {
    return EmptyDownloadView();
  }

  // Dialogs
  void _showAddPlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddPlaylistDialog(
          onPlaylistCreated: (name) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Yeni çalma listesi oluşturuldu: $name')),
            );
          },
        );
      },
    );
  }

  void _showSortingDialog() {
    final List<String> sortOptions = [
      'Son Çalınanlar',
      'Son Eklenenler',
      'Alfabetik',
      'Oluşturan',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return SortDialog(
          sortOptions: sortOptions,
          currentSortOrder: _sortOrder,
          onSortSelected: (option) {
            setState(() {
              _sortOrder = option;
            });
          },
        );
      },
    );
  }

  void _showPlaylistOptions(Playlist playlist) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return PlaylistOptionsBottomSheet(
          playlist: playlist,
          onFavoriteToggle: () {
            setState(() {
              FavoriteService.togglePlaylistFavorite(playlist.id);
            });
          },
        );
      },
    );
  }
}
