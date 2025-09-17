import 'dart:ui';
import 'package:flutter/material.dart';
import '../../model/playlist.dart';
import '../../model/song.dart';
import '../../service/playlist_manager.dart';
import 'process/playlist_detail_process.dart';

class PlaylistDetailPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailPage({required this.playlist, Key? key})
    : super(key: key);

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  late ScrollController _scrollController;
  bool _isAppBarExpanded = false;
  late PlaylistManager _playlistManager;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _isAppBarExpanded =
              _scrollController.hasClients &&
              _scrollController.offset > (200 - kToolbarHeight);
        });
      });
    _playlistManager = PlaylistManager();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _playSong(Song song, int index) {
    PlaylistDetailProcess.playSong(context, widget.playlist, song, index);
  }

  void _playAll({bool shuffle = false}) {
    PlaylistDetailProcess.playAll(context, widget.playlist, shuffle: shuffle);
  }

  @override
  Widget build(BuildContext context) {
    final durationText = PlaylistDetailProcess.calculateTotalDuration(
      widget.playlist.songs,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            backgroundColor: _isAppBarExpanded
                ? Colors.black
                : Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: _isAppBarExpanded
                  ? Text(
                      widget.playlist.name,
                      style: TextStyle(color: Colors.white),
                    )
                  : null,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Playlist cover image with blur effect
                  Image.network(widget.playlist.imageUrl, fit: BoxFit.cover),
                  // Overlay gradient for better visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.7),
                          Colors.black,
                        ],
                        stops: [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  PlaylistDetailProcess.isPlaylistFavorite(widget.playlist.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      PlaylistDetailProcess.isPlaylistFavorite(
                        widget.playlist.id,
                      )
                      ? Color(0xFF1DB954)
                      : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    PlaylistDetailProcess.togglePlaylistFavorite(
                      widget.playlist.id,
                    );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        PlaylistDetailProcess.isPlaylistFavorite(
                              widget.playlist.id,
                            )
                            ? 'Favorilere eklendi'
                            : 'Favorilerden çıkarıldı',
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  _showPlaylistOptions();
                },
              ),
            ],
          ),

          // Playlist info and controls
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Playlist name and info
                  if (!_isAppBarExpanded) ...[
                    Text(
                      widget.playlist.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],

                  // Description if available
                  if (widget.playlist.description.isNotEmpty) ...[
                    Text(
                      widget.playlist.description,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                  ],

                  // Creator and stats
                  Text(
                    'Oluşturan: ${widget.playlist.createdBy} • ${widget.playlist.songs.length} şarkı, $durationText',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(height: 16),

                  // Control buttons
                  Row(
                    children: [
                      // Play all
                      ElevatedButton(
                        onPressed: widget.playlist.songs.isNotEmpty
                            ? () => _playAll()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1DB954),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Çal',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      // Shuffle
                      OutlinedButton.icon(
                        onPressed: widget.playlist.songs.isNotEmpty
                            ? () => _playAll(shuffle: true)
                            : null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: Icon(Icons.shuffle, size: 16),
                        label: Text(
                          'Karıştır',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Spacer(),

                      // Download
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'İndirme özelliği henüz eklenmedi',
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.file_download_outlined,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Songs list
          // Songs list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final song = widget.playlist.songs[index];
              return PlaylistDetailProcess.buildSongItem(
                song: song,
                index: index,
                isFavorite: PlaylistDetailProcess.isSongFavorite(song.id),
                onTap: () => _playSong(song, index),
                onFavoriteToggle: () {
                  setState(() {
                    PlaylistDetailProcess.toggleSongFavorite(song.id);
                  });
                },
                onOptionsPressed: () => _showSongOptions(song),
              );
            }, childCount: widget.playlist.songs.length),
          ),
        ],
      ),
    );
  }

  void _showPlaylistOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF282828),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Düzenleme sayfasına yönlendir
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Düzenleme ekranı (yapım aşamasında)'),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(Icons.edit, color: Colors.white),
                title: Text('Düzenle', style: TextStyle(color: Colors.white)),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Paylaşım fonksiyonu
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Paylaşma ekranı (yapım aşamasında)')),
                );
              },
              child: ListTile(
                leading: Icon(Icons.share, color: Colors.white),
                title: Text('Paylaş', style: TextStyle(color: Colors.white)),
              ),
            ),
            if (!widget.playlist.createdBy.toLowerCase().contains(
              'spotify',
            )) ...[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Sil', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSongOptions(Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF282828),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  song.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(song.title, style: TextStyle(color: Colors.white)),
              subtitle: Text(
                song.artist,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Divider(color: Colors.white24),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Çalma listesine ekleme sayfası
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Çalma listesine ekleme ekranı (yapım aşamasında)',
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(Icons.playlist_add, color: Colors.white),
                title: Text(
                  'Çalma listesine ekle',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                PlaylistDetailProcess.toggleSongFavorite(song.id);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      PlaylistDetailProcess.isSongFavorite(song.id)
                          ? 'Favorilere eklendi'
                          : 'Favorilerden çıkarıldı',
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(
                  PlaylistDetailProcess.isSongFavorite(song.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: PlaylistDetailProcess.isSongFavorite(song.id)
                      ? Color(0xFF1DB954)
                      : Colors.white,
                ),
                title: Text(
                  PlaylistDetailProcess.isSongFavorite(song.id)
                      ? 'Favorilerden çıkar'
                      : 'Favorilere ekle',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Sanatçı sayfasına git
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sanatçı sayfası (yapım aşamasında)')),
                );
              },
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(
                  'Sanatçıya git',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Paylaşım fonksiyonu
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Paylaşma ekranı (yapım aşamasında)')),
                );
              },
              child: ListTile(
                leading: Icon(Icons.share, color: Colors.white),
                title: Text('Paylaş', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF282828),
        title: Text(
          'Çalma Listesini Sil',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '"${widget.playlist.name}" çalma listesini silmek istediğinizden emin misiniz?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text('İPTAL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final success = _playlistManager.deletePlaylist(
                widget.playlist.id,
              );
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Çalma listesi silindi')),
                );
                Navigator.pop(context); // Playlist detay sayfasından çık
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text('SİL'),
          ),
        ],
      ),
    );
  }
}
