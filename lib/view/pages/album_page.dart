import 'package:flutter/material.dart';
import '../../model/album.dart';
import 'process/album_process.dart';

class AlbumPage extends StatelessWidget {
  final Album album;

  const AlbumPage({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Albüme ait şarkıları getir
    final songs = AlbumProcess.getSongsForAlbum(album);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Albüm başlığı ve resmi
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(album.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(album.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Daha fazla seçenek
                },
              ),
            ],
          ),

          // Albüm bilgileri
          SliverToBoxAdapter(child: AlbumProcess.buildAlbumMeta(album, songs)),

          // Oynatma kontrolleri
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      // Favorilere ekle
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.download_outlined, color: Colors.white),
                    onPressed: () {
                      // İndir
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      // Paylaş
                    },
                  ),
                ],
              ),
            ),
          ),

          // Albüm şarkıları
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Şarkılar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: AlbumProcess.buildSongsList(songs, context),
          ),
        ],
      ),
    );
  }
}
