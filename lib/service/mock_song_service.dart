import '../model/song.dart';
import '../model/playlist.dart';
import '../model/artist.dart';
import '../model/album.dart';

class MockSongService {
  // Türk Sanatçıları ve Şarkıları kategorilere ayrılmış şekilde
  static List<Song> getSongs() {
    return [
      // --- Pop ---
      Song(
        id: '1',
        title: 'Haydi Gel Benimle Ol',
        artist: 'Sezen Aksu',
        album: 'Sen Ağlama',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/101/200',
        audioUrl: 'https://aexpan.tr/aexpcustomfileurl/0919fd1de3/a77b696b50',
      ),
      Song(
        id: '2',
        title: 'Şımarık',
        artist: 'Tarkan',
        album: 'Ölürüm Sana',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/102/200',
        audioUrl: '',
      ),
      Song(
        id: '3',
        title: 'Rakkas',
        artist: 'Sezen Aksu',
        album: 'Adı Bende Saklı',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/103/200',
        audioUrl: '',
      ),
      Song(
        id: '4',
        title: 'Kiss Kiss',
        artist: 'Tarkan',
        album: 'Come Closer',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/104/200',
        audioUrl: '',
      ),
      Song(
        id: '5',
        title: 'Dudu',
        artist: 'Tarkan',
        album: 'Dudu',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/1011/200',
        audioUrl: '',
      ),
      Song(
        id: '6',
        title: 'Yalnızlık Senfonisi',
        artist: 'Sertab Erener',
        album: 'Sertab Erener',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/106/200',
        audioUrl: '',
      ),
      Song(
        id: '7',
        title: 'Unutamadım',
        artist: 'Sertab Erener',
        album: 'Sertab Gibi',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/107/200',
        audioUrl: '',
      ),
      Song(
        id: '8',
        title: 'Tutamıyorum Zamanı',
        artist: 'Kenan Doğulu',
        album: 'Ex Aşkım',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/108/200',
        audioUrl: '',
      ),
      Song(
        id: '9',
        title: 'Kal Yanımda',
        artist: 'Kenan Doğulu',
        album: 'Ex Aşkım',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/109/200',
        audioUrl: '',
      ),
      Song(
        id: '10',
        title: 'Ben Öyle Birini Sevdim ki',
        artist: 'Sezen Aksu',
        album: 'Delibal Original Soundtrack',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/110/200',
        audioUrl: '',
      ),

      // --- Anadolu Rock ---
      Song(
        id: '11',
        title: 'Gülpembe',
        artist: 'Barış Manço',
        album: '24 Ayar Manço',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/111/200',
        audioUrl: '',
      ),
      Song(
        id: '12',
        title: 'Resimdeki Gözyaşları',
        artist: 'Cem Karaca',
        album: 'Yoksulluk Kader Olamaz',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/112/200',
        audioUrl: '',
      ),
      Song(
        id: '13',
        title: 'Sarı Çizmeli Mehmet Ağa',
        artist: 'Barış Manço',
        album: 'Mançoloji',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/113/200',
        audioUrl: '',
      ),
      Song(
        id: '14',
        title: 'Islak Islak',
        artist: 'Erkin Koray',
        album: 'Elektronik Türküler',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/114/200',
        audioUrl: '',
      ),
      Song(
        id: '15',
        title: 'Obur Dünya',
        artist: 'Cem Karaca',
        album: 'Tamirci Çırağı',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/115/200',
        audioUrl: '',
      ),
      Song(
        id: '16',
        title: 'Ahmet Bey\'in Ceketi',
        artist: 'Barış Manço',
        album: 'Mançoloji',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/116/200',
        audioUrl: '',
      ),
      Song(
        id: '17',
        title: 'Dönence',
        artist: 'Barış Manço',
        album: 'Yeni Bir Gün',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/117/200',
        audioUrl: '',
      ),
      Song(
        id: '18',
        title: 'Felekten Bir Gece',
        artist: 'Erkin Koray',
        album: 'Meçhul',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/118/200',
        audioUrl: '',
      ),
      Song(
        id: '19',
        title: 'Deniz Üstü Köpürür',
        artist: 'Cem Karaca',
        album: 'Safinaz',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/119/200',
        audioUrl: '',
      ),
      Song(
        id: '20',
        title: 'Herkes Gibisin',
        artist: 'Edip Akbayram',
        album: 'Edebi Kal',
        genre: 'Anadolu Rock',
        imageUrl: 'https://picsum.photos/id/120/200',
        audioUrl: '',
      ),

      // --- Türk Halk Müziği --- :cite[1]
      Song(
        id: '21',
        title: 'Dost Elinden',
        artist: 'Belkıs Akkale',
        album: 'Türk Halk Müziği Klasikleri',
        genre: 'Türk Halk Müziği',
        imageUrl: 'https://picsum.photos/id/121/200',
        audioUrl: '',
      ),
      Song(
        id: '22',
        title: 'Yüksek Yüksek Tepelere',
        artist: 'Güler Duman',
        album: 'Türkülerle Anadolu',
        genre: 'Türk Halk Müziği',
        imageUrl: 'https://picsum.photos/id/122/200',
        audioUrl: '',
      ),
      Song(
        id: '23',
        title: 'Kalenin Bedenleri',
        artist: 'Musa Eroğlu',
        album: 'Anadolu Türküleri',
        genre: 'Türk Halk Müziği',
        imageUrl: 'https://picsum.photos/id/123/200',
        audioUrl: '',
      ),
      Song(
        id: '24',
        title: 'Allı Turnam',
        artist: 'Selda Bağcan',
        album: 'Türkülerimiz',
        genre: 'Türk Halk Müziği',
        imageUrl: 'https://picsum.photos/id/124/200',
        audioUrl: '',
      ),
      Song(
        id: '25',
        title: 'Yemen Türküsü',
        artist: 'Hasret Gültekin',
        album: 'Halk Türküleri',
        genre: 'Türk Halk Müziği',
        imageUrl: 'https://picsum.photos/id/125/200',
        audioUrl: '',
      ),

      // --- Diğer Popüler Şarkılar --- :cite[3]
      Song(
        id: '26',
        title: 'Feryat',
        artist: 'Mustafa Sandal',
        album: 'Gölgede Aynı',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/126/200',
        audioUrl: '',
      ),
      Song(
        id: '27',
        title: 'Kır Zincirlerini',
        artist: 'Mustafa Sandal',
        album: 'Detay',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/127/200',
        audioUrl: '',
      ),
      Song(
        id: '28',
        title: 'Yandım',
        artist: 'Tarkan',
        album: 'Come Closer',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/128/200',
        audioUrl: '',
      ),
      Song(
        id: '29',
        title: 'Ağla Sevdam',
        artist: 'Kenan Doğulu',
        album: 'Ex Aşkım',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/129/200',
        audioUrl: '',
      ),
      Song(
        id: '30',
        title: 'Yalnızlık Paylaşılmaz',
        artist: 'Sertab Erener',
        album: 'Sakin Ol!',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/130/200',
        audioUrl: '',
      ),

      // --- Alternatif / Diğer Türler ---
      Song(
        id: '31',
        title: 'Sigara',
        artist: 'Duman',
        album: 'Belki Alışman Lazım',
        genre: 'Alternatif Rock',
        imageUrl: 'https://picsum.photos/id/131/200',
        audioUrl: '',
      ),
      Song(
        id: '32',
        title: 'Bu Son Olsun',
        artist: 'Duman',
        album: 'Seni Kendime Sakladım',
        genre: 'Alternatif Rock',
        imageUrl: 'https://picsum.photos/id/132/200',
        audioUrl: '',
      ),
      Song(
        id: '33',
        title: 'Bir Kadın Çizeceksin',
        artist: 'Mor ve Ötesi',
        album: 'Dünya Yalan Söylüyor',
        genre: 'Alternatif Rock',
        imageUrl: 'https://picsum.photos/id/133/200',
        audioUrl: '',
      ),
      Song(
        id: '34',
        title: 'Cambaz',
        artist: 'Mor ve Ötesi',
        album: 'Bir',
        genre: 'Alternatif Rock',
        imageUrl: 'https://picsum.photos/id/134/200',
        audioUrl: '',
      ),
      Song(
        id: '35',
        title: 'Tutuklu',
        artist: 'Sezen Aksu',
        album: 'Tutuklu',
        genre: 'Pop',
        imageUrl: 'https://picsum.photos/id/135/200',
        audioUrl: '',
      ),
    ];
  }

  // Şarkıları genre'ye göre filtreleyen yardımcı metod
  static List<Song> getSongsByGenre(String genre) {
    return getSongs().where((song) => song.genre == genre).toList();
  }

  // Kategorilere göre çalma listeleri
  static List<Playlist> getPlaylists() {
    final popTurkce = getSongsByGenre('Pop');
    final anadoluRock = getSongsByGenre('Anadolu Rock');
    final turkHalkMuzigi = getSongsByGenre('Türk Halk Müziği');
    final alternatifRock = getSongsByGenre('Alternatif Rock');
    final allSongs = getSongs();

    return [
      Playlist(
        id: '1',
        name: 'Türkçe Pop Hitleri',
        description: 'Türkiye\'nin en popüler pop şarkıları',
        imageUrl: 'https://picsum.photos/id/30/200',
        createdBy: 'Spotify',
        songs: popTurkce,
      ),
      Playlist(
        id: '2',
        name: 'Anadolu Rock Klasikleri',
        description: 'Barış Manço\'dan Cem Karaca\'ya efsaneler',
        imageUrl: 'https://picsum.photos/id/31/200',
        createdBy: 'Spotify',
        songs: anadoluRock,
      ),
      Playlist(
        id: '3',
        name: 'Türk Halk Müziği Seçkisi',
        description: 'Anadolu\'nun türküleri',
        imageUrl: 'https://picsum.photos/id/32/200',
        createdBy: 'Spotify',
        songs: turkHalkMuzigi,
      ),
      Playlist(
        id: '4',
        name: 'Alternatif Türkçe',
        description: 'Yeni nesil farklı sesler',
        imageUrl: 'https://picsum.photos/id/33/200',
        createdBy: 'Spotify',
        songs: alternatifRock,
      ),
      Playlist(
        id: '5',
        name: 'Sezen Aksu Koleksiyonu',
        description: 'Türk popunun kraliçesinden en iyiler',
        imageUrl: 'https://picsum.photos/id/34/200',
        createdBy: 'Spotify',
        songs: allSongs.where((s) => s.artist == 'Sezen Aksu').toList(),
      ),
      Playlist(
        id: '6',
        name: 'Tarkan En İyiler',
        description: 'Süperstardan unutulmaz şarkılar',
        imageUrl: 'https://picsum.photos/id/35/200',
        createdBy: 'Spotify',
        songs: allSongs.where((s) => s.artist == 'Tarkan').toList(),
      ),
      Playlist(
        id: '7',
        name: 'Gece Modu',
        description: 'Gece yolculuklarına uygun şarkılar',
        imageUrl: 'https://picsum.photos/id/36/200',
        createdBy: 'Spotify',
        songs: [...popTurkce.take(5), ...anadoluRock.take(3)],
      ),
      Playlist(
        id: '8',
        name: 'Nostalji Kutusu',
        description: 'Eskilere gidip gelmek isteyenler için',
        imageUrl: 'https://picsum.photos/id/37/200',
        createdBy: 'Spotify',
        songs: [
          ...anadoluRock.take(6),
          ...allSongs.where((s) => s.artist.contains('Sezen Aksu')).take(4),
        ],
      ),
    ];
  }

  // Rastgele şarkı seçme yardımcı metodu
  static List<Song> _getRandomSongs(List<Song> source, int count) {
    if (source.isEmpty) return [];
    if (source.length <= count) return List.from(source);

    final songs = <Song>[];
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < count; i++) {
      final index = (random + i) % source.length;
      songs.add(source[index]);
    }

    return songs;
  }

  // Türk sanatçıları ve şarkıları :cite[1]:cite[3]:cite[6]
  static List<Artist> getArtists() {
    final songs = getSongs();

    return [
      Artist(
        id: '1',
        name: 'Sezen Aksu',
        imageUrl: 'https://picsum.photos/id/40/200',
        bio:
            'Türk pop müziğinin mihenk taşı, besteci ve söz yazarı. 1970\'lerden günümüze Türk müziğine yön veren efsanevi isim.',
        songs: songs.where((s) => s.artist.contains('Sezen Aksu')).toList(),
      ),
      Artist(
        id: '2',
        name: 'Tarkan',
        imageUrl: 'https://picsum.photos/id/41/200',
        bio:
            'Uluslararası başarıya ulaşmış Türk pop yıldızı. "Şımarık" şarkısıyla dünya çapında ün kazandı.',
        songs: songs.where((s) => s.artist.contains('Tarkan')).toList(),
      ),
      Artist(
        id: '3',
        name: 'Barış Manço',
        imageUrl: 'https://picsum.photos/id/42/200',
        bio:
            'Türk rock müziğinin öncülerinden, kültür elçisi. "Adam Olacak Çocuk" programıyla nesillere dokundu.',
        songs: songs.where((s) => s.artist.contains('Barış Manço')).toList(),
      ),
      Artist(
        id: '4',
        name: 'Sertab Erener',
        imageUrl: 'https://picsum.photos/id/43/200',
        bio:
            'Türk pop müziğinin güçlü sesi. 2003 Eurovision Şarkı Yarışması\'nı kazanarak ülkemize birincilik getirdi.',
        songs: songs.where((s) => s.artist.contains('Sertab Erener')).toList(),
      ),
      Artist(
        id: '5',
        name: 'Kenan Doğulu',
        imageUrl: 'https://picsum.photos/id/44/200',
        bio:
            'Türk pop müziğinin önemli temsilcilerinden. "Tutamıyorum Zamanı" gibi birçok hit şarkının yaratıcısı.',
        songs: songs.where((s) => s.artist.contains('Kenan Doğulu')).toList(),
      ),
      Artist(
        id: '6',
        name: 'Erkin Koray',
        imageUrl: 'https://picsum.photos/id/45/200',
        bio:
            'Anadolu rock\'ın babası olarak anılan efsane. Türk rock müziğinin temellerini atan isimlerden biri.',
        songs: songs.where((s) => s.artist.contains('Erkin Koray')).toList(),
      ),
      Artist(
        id: '7',
        name: 'Cem Karaca',
        imageUrl: 'https://picsum.photos/id/46/200',
        bio:
            'Anadolu rock\'ın unutulmaz sesi ve kültür ikonu. "Resimdeki Gözyaşları" gibi ölümsüz eserler bıraktı.',
        songs: songs.where((s) => s.artist.contains('Cem Karaca')).toList(),
      ),
      Artist(
        id: '8',
        name: 'Güler Duman',
        imageUrl: 'https://picsum.photos/id/47/200',
        bio:
            'Türk halk müziğinin sevilen sesi. "Yüksek Yüksek Tepelere" gibi türküleriyle hafızalara kazındı. :cite[1]',
        songs: songs.where((s) => s.artist.contains('Güler Duman')).toList(),
      ),
      Artist(
        id: '9',
        name: 'Belkıs Akkale',
        imageUrl: 'https://picsum.photos/id/48/200',
        bio:
            'Türk halk müziği sanatçısı. "Dost Elinden" gibi birçok türküyü seslendirdi. :cite[1]',
        songs: songs.where((s) => s.artist.contains('Belkıs Akkale')).toList(),
      ),
      Artist(
        id: '10',
        name: 'Mor ve Ötesi',
        imageUrl: 'https://picsum.photos/id/49/200',
        bio:
            'Türk alternatif rock müziğinin önemli temsilcisi. "Bir Derdim Var" ve "Cambaz" gibi hit şarkılarıyla tanınıyor.',
        songs: songs.where((s) => s.artist.contains('Mor ve Ötesi')).toList(),
      ),
    ];
  }

  // Albümleri getir
  static List<Album> getAlbums() {
    final albums = <Album>[];
    final albumSongs = <String, List<String>>{};
    final albumCovers = <String, String>{};
    final albumArtists = <String, String>{};

    // Önce tüm şarkıları dolaşarak albümleri ve şarkıları topla
    for (final song in getSongs()) {
      final key = '${song.artist}:${song.album}';
      if (song.album.isNotEmpty) {
        // Albüm şarkılarını topla
        if (!albumSongs.containsKey(key)) {
          albumSongs[key] = [];
          albumCovers[key] = song.imageUrl;
          albumArtists[key] = song.artist;
        }
        albumSongs[key]!.add(song.id);
      }
    }

    // Şimdi toplanan verileri kullanarak albümleri oluştur
    int albumIndex = 1;
    albumSongs.forEach((key, songIds) {
      final parts = key.split(':');
      final artist = parts[0];
      final albumName = parts[1];

      // Albüm bilgilerini oluştur
      final album = Album(
        id: 'album-${albumIndex++}',
        name: albumName,
        artist: artist,
        imageUrl: albumCovers[key]!,
        year: getRandomYear(1980, 2023),
        songIds: songIds,
      );

      albums.add(album);
    });

    return albums;
  }

  // Yardımcı metod: Rastgele yıl üretir
  static int getRandomYear(int start, int end) {
    return start + (DateTime.now().millisecondsSinceEpoch % (end - start + 1));
  }

  // Bir sanatçının albümlerini getir
  static List<Album> getAlbumsByArtist(String artistName) {
    return getAlbums().where((album) => album.artist == artistName).toList();
  }

  // Tüm türleri getir
  static List<String> getAllGenres() {
    final Set<String> genres = {};
    getSongs().forEach((song) {
      if (song.genre.isNotEmpty) {
        genres.add(song.genre);
      }
    });
    return genres.toList();
  }

  // Arama işlevleri
  static List<Song> searchSongs(String query) {
    query = query.toLowerCase();
    return getSongs().where((song) {
      return song.title.toLowerCase().contains(query) ||
          song.artist.toLowerCase().contains(query) ||
          song.album.toLowerCase().contains(query) ||
          song.genre.toLowerCase().contains(query);
    }).toList();
  }

  static List<Album> searchAlbums(String query) {
    query = query.toLowerCase();
    return getAlbums().where((album) {
      return album.name.toLowerCase().contains(query) ||
          album.artist.toLowerCase().contains(query);
    }).toList();
  }

  static List<Artist> searchArtists(String query) {
    query = query.toLowerCase();
    return getArtists().where((artist) {
      return artist.name.toLowerCase().contains(query) ||
          artist.bio.toLowerCase().contains(query);
    }).toList();
  }

  static List<Playlist> searchPlaylists(String query) {
    query = query.toLowerCase();
    return getPlaylists().where((playlist) {
      return playlist.name.toLowerCase().contains(query) ||
          playlist.description.toLowerCase().contains(query) ||
          playlist.createdBy.toLowerCase().contains(query);
    }).toList();
  }

  // Tümünü ara (birleşik arama)
  static Map<String, dynamic> searchAll(String query) {
    return {
      'songs': searchSongs(query),
      'albums': searchAlbums(query),
      'artists': searchArtists(query),
      'playlists': searchPlaylists(query),
    };
  }
}
