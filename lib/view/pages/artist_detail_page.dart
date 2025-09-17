import 'package:flutter/material.dart';
import '../../model/artist.dart' show Artist;
import '../../model/song.dart';
import '../../service/mock_song_service.dart';
import '../../service/favorite_service.dart';

class ArtistDetailPage extends StatefulWidget {
  final Artist artist;

  const ArtistDetailPage({required this.artist, Key? key}) : super(key: key);

  @override
  _ArtistDetailPageState createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  bool _isFollowing = false;

  // Şarkı seçeneklerini göster
  void _showSongOptionsMenu(Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF282828),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
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
              subtitle: Text(song.artist, style: TextStyle(color: Colors.grey)),
            ),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(Icons.add_to_queue, color: Colors.white),
              title: Text(
                'Çalma sırasına ekle',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Çalma sırasına eklendi')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_add, color: Colors.white),
              title: Text(
                'Çalma listesine ekle',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Çalma listesine ekleme ekranı (yapım aşamasında)',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                FavoriteService.isSongFavorite(song.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.white,
              ),
              title: Text(
                FavoriteService.isSongFavorite(song.id)
                    ? 'Beğenmekten vazgeç'
                    : 'Beğen',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  FavoriteService.toggleSongFavorite(song.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      FavoriteService.isSongFavorite(song.id)
                          ? 'Favorilere eklendi'
                          : 'Favorilerden çıkarıldı',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.album, color: Colors.white),
              title: Text('Albüme git', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Albüm sayfası (yapım aşamasında)')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.white),
              title: Text('Paylaş', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Paylaşma ekranı (yapım aşamasında)')),
                );
              },
            ),
            SizedBox(height: 8),
          ],
        );
      },
    );
  }

  // Sanatçılar için gerçekçi dinleyici sayıları
  String _formatListenerCount(String artistName) {
    // Sanatçı adına göre sabit ve gerçekçi sayılar döndür
    Map<String, String> artistListeners = {
      'The Weeknd': '92,845,690',
      'Dua Lipa': '65,384,291',
      'Justin Bieber': '71,506,382',
      'Olivia Rodrigo': '48,912,375',
      'Ed Sheeran': '82,760,184',
      'Harry Styles': '78,231,456',
      'Lil Nas X': '53,485,729',
    };

    // Eğer sanatçı listedeyse o değeri döndür, yoksa rastgele ama makul bir değer
    return artistListeners[artistName] ??
        '${(10000000 + artistName.length * 1000000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  Widget _buildFollowButton() {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _isFollowing = !_isFollowing;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFollowing
                  ? '${widget.artist.name} takip ediliyor'
                  : '${widget.artist.name} takip edilmiyor',
            ),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: _isFollowing ? Color(0xFF1DB954) : Colors.white,
          width: 1.5,
        ),
        backgroundColor: _isFollowing
            ? Color(0xFF1DB954).withOpacity(0.2)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        _isFollowing ? 'Takip ediliyor' : 'Takip et',
        style: TextStyle(
          color: _isFollowing ? Color(0xFF1DB954) : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Sanatçı resmi ve bilgileriyle sliver app bar
          SliverAppBar(
            expandedHeight: 340.0,
            pinned: true,
            backgroundColor: Colors.black.withOpacity(0.85),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.artist.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Artist image
                  Image.network(
                    widget.artist.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    },
                  ),
                  // Daha iyi metin görünürlüğü için gradyan ekleme
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.8),
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
                  FavoriteService.isArtistFavorite(widget.artist.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: FavoriteService.isArtistFavorite(widget.artist.id)
                      ? Color(0xFF1DB954)
                      : Colors.white,
                ),
                onPressed: () {
                  // Favorilere ekle
                  FavoriteService.toggleArtistFavorite(widget.artist.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        FavoriteService.isArtistFavorite(widget.artist.id)
                            ? '${widget.artist.name} added to favorites'
                            : '${widget.artist.name} removed from favorites',
                      ),
                    ),
                  );
                  // Refresh UI
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Daha fazla seçenek göster
                },
              ),
            ],
          ),

          // İstatistikler ve eylem düğmeleri
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aylık dinleyiciler
                  Text(
                    '${_formatListenerCount(widget.artist.name)} monthly listeners',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Shuffle play
                          if (widget.artist.songs.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              '/player',
                              arguments: widget.artist.songs.first,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Shuffle play başlatıldı'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1DB954),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Karıştır ve Çal',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      _buildFollowButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Popüler şarkılar bölümü
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                'Popüler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Songs list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final song = widget.artist.songs[index];
              return InkWell(
                onTap: () {
                  // Play song
                  Navigator.pushNamed(context, '/player', arguments: song);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              song.imageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.white24,
                                onTap: () {
                                  // Resme tıklandığında çal
                                  Navigator.pushNamed(
                                    context,
                                    '/player',
                                    arguments: song,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        song.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${song.album} • ${song.artist}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              FavoriteService.isSongFavorite(song.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: FavoriteService.isSongFavorite(song.id)
                                  ? Color(0xFF1DB954)
                                  : Colors.white,
                            ),
                            splashColor: Colors.white24,
                            onPressed: () {
                              FavoriteService.toggleSongFavorite(song.id);
                              // Favorilere ekle
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    FavoriteService.isSongFavorite(song.id)
                                        ? 'Favorilere eklendi'
                                        : 'Favorilerden çıkarıldı',
                                  ),
                                ),
                              );
                              // Refresh UI
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            splashColor: Colors.white24,
                            onPressed: () {
                              // Şarkı seçeneklerini göster
                              _showSongOptionsMenu(song);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: widget.artist.songs.length),
          ),

          // Albums section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Albums',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.artist.songs.length,
                      separatorBuilder: (_, __) => SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final song = widget.artist.songs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/player',
                                    arguments: song,
                                  );
                                },
                                child: Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      song.imageUrl,
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Albüm sayfası (yapım aşamasında)',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                song.album,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Benzer sanatçılar bölümü
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fans also like',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: MockSongService.getArtists()
                          .where((a) => a.id != widget.artist.id)
                          .length,
                      separatorBuilder: (_, __) => SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final similarArtists = MockSongService.getArtists()
                            .where((a) => a.id != widget.artist.id)
                            .toList();
                        final similarArtist = similarArtists[index];
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(60),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/artist_detail',
                                arguments: similarArtist,
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      similarArtist.imageUrl,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  similarArtist.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom space
          SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }
}
