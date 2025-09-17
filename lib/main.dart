import 'package:flutter/material.dart';
import 'view/pages/home_page.dart';
import 'view/pages/search_page.dart';
import 'view/pages/player_page.dart';
import 'view/pages/library_page.dart';
import 'view/pages/playlists_page.dart';
import 'view/pages/create_playlist_page.dart';
import 'view/pages/playlist_detail_page.dart';
import 'view/pages/artist_detail_page.dart';
import 'view/pages/album_page.dart'; // Yeni eklendi
import 'service/player_service.dart';
import 'service/mock_song_service.dart';
import 'view/component/component.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Uygulama verilerinin yüklenmesini simüle et
  await Future.delayed(Duration(milliseconds: 500));

  runApp(SpoclonApp());
}

class SpoclonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify',
      theme: ThemeData(
        primaryColor: Color(0xFF1DB954),
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF1DB954),
          secondary: Color(0xFF1DB954),
        ),
        fontFamily: 'Gotham',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
        brightness: Brightness.dark,
      ),
      home: MainNavigation(),
      routes: {
        '/playlists': (context) => PlaylistsPage(),
        '/create_playlist': (context) => CreatePlaylistPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/playlist_detail') {
          final playlist = settings.arguments as dynamic;
          return MaterialPageRoute(
            builder: (context) => PlaylistDetailPage(playlist: playlist),
          );
        } else if (settings.name == '/artist_detail') {
          final artist = settings.arguments as dynamic;
          return MaterialPageRoute(
            builder: (context) => ArtistDetailPage(artist: artist),
          );
        } else if (settings.name == '/player') {
          final song = settings.arguments as dynamic;
          return MaterialPageRoute(
            builder: (context) => PlayerPage(song: song),
          );
        } else if (settings.name == '/album_detail') {
          final album = settings.arguments as dynamic;
          return MaterialPageRoute(
            builder: (context) => AlbumPage(album: album),
          );
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('Sayfa bulunamadı: ${settings.name}')),
          ),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomePage(), SearchPage(), LibraryPage()];
  final playerService = PlayerService();

  @override
  void initState() {
    super.initState();
    // Başlangıçta bir şarkı yükle ama otomatik başlatma (demo amaçlı)
    final demoSong = MockSongService.getSongs().first;
    playerService.playSong(demoSong, autoPlay: false);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ana sayfa içeriği
          _pages[_selectedIndex],

          // Mini Player (eğer bir şarkı çalıyorsa)
          if (playerService.currentSong != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: playerService,
                builder: (context, _) {
                  return MiniPlayer(
                    currentSong: playerService.currentSong!,
                    onTap: () {
                      // Oynatıcı sayfasına git
                      Navigator.pushNamed(
                        context,
                        '/player',
                        arguments: playerService.currentSong,
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF121212),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Arama'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Kütüphane',
          ),
        ],
      ),
    );
  }
}
