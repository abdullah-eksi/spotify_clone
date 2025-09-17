import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../model/song.dart';
import '../../service/mock_song_service.dart';
import '../../service/playlist_manager.dart';
import '../../service/player_service.dart';
import 'process/player_process.dart';

import 'package:spoclon/view/component/component.dart';

class PlayerPage extends StatefulWidget {
  final Song? song;

  const PlayerPage({Key? key, this.song}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  late Song _currentSong;
  bool _isShuffle = false;
  bool _isRepeat = false;
  double _currentPosition = 0;
  double _totalDuration = 180; // 3 dakika varsayılan süre

  late PlaylistManager _playlistManager;
  bool _autoPlayNextSong = true;
  final PlayerService _playerService = PlayerService();

  late AnimationController _playPauseController;

  // Simüle edilmiş oynatma için zamanlayıcı
  Timer? _playbackTimer;

  @override
  void initState() {
    super.initState();
    _currentSong =
        widget.song ??
        _playerService.currentSong ??
        MockSongService.getSongs()[0];

    // Şarkıyı hazırla ama otomatik başlatma
    if (widget.song != null) {
      // Önceki çalmayı durdur
      if (_playerService.isPlaying) {
        _playerService.pauseSong();
      }
      _playerService.playSong(_currentSong, autoPlay: false);
    }

    _playlistManager = PlaylistManager();

    // Default değerler
    _isShuffle = false;

    _playPauseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Başlangıçta oynatma düğmesi her zaman "play" durumunda olsun
    _playPauseController.reverse();

    // Oynatma durumunun tutarlı olduğundan emin ol
    if (_playerService.isPlaying) {
      _playerService.pauseSong();
    }

    // Gerçek ses çalma için işleyiciler ekle
    _setupAudioPlayerListeners();
  }

  void _setupAudioPlayerListeners() {
    if (_currentSong.audioUrl.isNotEmpty &&
        _playerService.audioPlayer != null) {
      // Ses dosyasının gerçek süresini al
      _playerService.audioPlayer?.durationStream.listen((duration) {
        if (duration != null && mounted) {
          setState(() {
            // Gerçek ses dosyası süresini kullan
            _totalDuration = duration.inSeconds.toDouble();
          });
        }
      });

      // Pozisyon değişikliklerini dinle
      _playerService.audioPlayer?.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentPosition = position.inSeconds.toDouble();
          });
        }
      });

      // Tamamlama olayını dinle
      _playerService.audioPlayer?.processingStateStream.listen((state) {
        if (state == ProcessingState.completed) {
          if (_isRepeat) {
            // Tekrar modu açıksa şarkıyı yeniden başlat
            _playerService.audioPlayer?.seek(Duration.zero);
            _playerService.audioPlayer?.play();
          } else {
            // Şarkıyı bitir ve sonrakine geç
            _playNextSong();
          }
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Oynatmayı UI güvenli bir şekilde başlat
    if (_playbackTimer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _togglePlayPause();
      });
    }
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _playPauseController.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (!mounted) return;

    // Oynatılacak mı yoksa durdurulacak mı tespit et
    final willBePlaying = !_playerService.isPlaying;

    // Asenkron işlemden önce UI'ı hemen güncelle
    if (willBePlaying) {
      _playPauseController.forward();
    } else {
      _playPauseController.reverse();
      // Duraklatırken, simülasyonu hemen durdur
      _stopPlaybackSimulation();
    }

    // UI güncellemesini zorla
    setState(() {});

    // Sonra asıl geçiş işlemini gerçekleştir (asenkron)
    bool isPlaying = await PlayerProcess.togglePlayPause(_playerService);

    // Herhangi bir uç durumu ele almak için son kontrol
    if (mounted) {
      // Kontrolörün doğru pozisyonda olduğundan emin ol
      if (isPlaying &&
          _playPauseController.status != AnimationStatus.completed) {
        _playPauseController.forward();
      } else if (!isPlaying &&
          _playPauseController.status != AnimationStatus.dismissed) {
        _playPauseController.reverse();
      }

      // Oynatma simülasyonunu yönet
      setState(() {
        if (isPlaying && _currentSong.audioUrl.isEmpty) {
          _startPlaybackSimulation();
        } else if (!isPlaying) {
          _stopPlaybackSimulation();
        }
      });
    }
  }

  Future<void> _playNextSong() async {
    // Önce çalan müziği durdur
    if (_playerService.isPlaying) {
      await _playerService.pauseSong();
    }

    Song? nextSong = await PlayerProcess.playNextSong(
      _playlistManager,
      _playerService,
    );

    if (nextSong != null) {
      // Oynatma düğmesi durumunu sıfırla
      _playPauseController.reverse();
      _stopPlaybackSimulation();

      setState(() {
        _currentSong = nextSong;
        _currentPosition = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sonraki şarkı: ${_currentSong.title}'),
          duration: Duration(seconds: 1),
        ),
      );

      if (_playerService.isPlaying && _currentSong.audioUrl.isEmpty) {
        // Sadece ses URL'i yoksa simülasyon başlat
        _startPlaybackSimulation();
      }
    } else if (_autoPlayNextSong) {
      // Playlist bitti, rastgele şarkı çal
      final randomSong = _playlistManager.getRandomSongAfterPlaylistEnds();
      setState(() {
        _currentSong = randomSong;
        _playerService.playSong(_currentSong, autoPlay: false);
        _currentPosition = 0;
        if (_playerService.isPlaying) {
          _startPlaybackSimulation();
        }
      });

      // Bildirim göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Çalma listesi bitti. Rastgele şarkı çalınıyor...'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _playPreviousSong() async {
    // Önce çalan müziği durdur
    if (_playerService.isPlaying) {
      await _playerService.pauseSong();
    }

    Song? previousSong = await PlayerProcess.playPreviousSong(
      _playlistManager,
      _playerService,
    );

    if (previousSong != null) {
      // Oynatma düğmesi durumunu sıfırla
      _playPauseController.reverse();
      _stopPlaybackSimulation();

      setState(() {
        _currentSong = previousSong;
        _currentPosition = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Önceki şarkı: ${_currentSong.title}'),
          duration: Duration(seconds: 1),
        ),
      );

      if (_playerService.isPlaying && _currentSong.audioUrl.isEmpty) {
        // Sadece ses URL'i yoksa simülasyon başlat
        _startPlaybackSimulation();
      }
    }
  }

  void _startPlaybackSimulation() {
    // Eğer şarkının ses URL'i varsa, simülasyon kullanma
    if (_currentSong.audioUrl.isNotEmpty) {
      // Gerçek ses çalındığında simüle etmeye gerek yok
      return;
    }

    // Önceki zamanlayıcıyı iptal et
    _playbackTimer?.cancel();

    // 1 saniyede bir ilerleme çubuğunu güncelle
    _playbackTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted && _playerService.isPlaying) {
        setState(() {
          _currentPosition += 1;
          if (_currentPosition >= _totalDuration) {
            if (_isRepeat) {
              // Tekrar modu açıksa şarkıyı yeniden başlat
              _currentPosition = 0;
            } else {
              // Şarkıyı bitir ve sonrakine geç
              _currentPosition = 0;
              _playNextSong();
            }
          }
        });
      }
    });
  }

  void _stopPlaybackSimulation() {
    _playbackTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: PlayerAppBar(
        albumName: _currentSong.album,
        onBackTap: () => Navigator.pop(context),
        onMoreTap: () => _showSongOptions(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1DB954).withOpacity(0.7), Colors.black],
            stops: [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: AlbumCover(
                      imageUrl: _currentSong.imageUrl,
                      shadow: BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ),
                  ),
                ),
              ),
              TrackInfo(
                song: _currentSong,
                isFavorite: PlayerProcess.isFavorite(_currentSong),
                onFavoriteToggle: () {
                  setState(() {
                    PlayerProcess.toggleFavorite(_currentSong);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        PlayerProcess.isFavorite(_currentSong)
                            ? 'Favorilere eklendi'
                            : 'Favorilerden çıkarıldı',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ProgressBar(
                  currentPosition: _currentPosition,
                  totalDuration: _totalDuration,
                  onChanged: (double value) {
                    setState(() {
                      _currentPosition = value;
                    });

                    // Eğer gerçek audio çalıyorsa ve audioPlayer hazırsa, seek işlemi yap
                    if (_currentSong.audioUrl.isNotEmpty &&
                        _playerService.audioPlayer != null) {
                      try {
                        _playerService.audioPlayer?.seek(
                          Duration(seconds: value.toInt()),
                        );
                      } catch (e) {
                        print('Error seeking audio: $e');
                      }
                    }
                  },
                  formatDuration: _formatDuration,
                ),
              ),
              SizedBox(height: 16),
              // Playback controls
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: PlaybackControls(
                  isShuffle: _isShuffle,
                  isRepeat: _isRepeat,
                  onShuffleToggle: () {
                    setState(() {
                      _isShuffle = PlayerProcess.toggleShuffle(
                        _playlistManager,
                      );
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isShuffle ? 'Karıştırma açık' : 'Karıştırma kapalı',
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  onRepeatToggle: () {
                    setState(() {
                      _isRepeat = PlayerProcess.toggleRepeat(_playlistManager);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isRepeat ? 'Tekrarlama açık' : 'Tekrarlama kapalı',
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  onPreviousTrack: _playPreviousSong,
                  onPlayPause: _togglePlayPause,
                  onNextTrack: _playNextSong,
                  playPauseController: _playPauseController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds - minutes * 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showSongOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_currentSong.imageUrl),
                ),
                title: Text(
                  _currentSong.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _currentSong.artist,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Divider(color: Colors.grey[800]),
              ListTile(
                leading: Icon(Icons.playlist_add, color: Colors.white),
                title: Text(
                  'Çalma listesine ekle',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showAddToPlaylistDialog();
                },
              ),
              ListTile(
                leading: Icon(
                  PlayerProcess.isFavorite(_currentSong)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: PlayerProcess.isFavorite(_currentSong)
                      ? Color(0xFF1DB954)
                      : Colors.white,
                ),
                title: Text(
                  PlayerProcess.isFavorite(_currentSong)
                      ? 'Favorilerden çıkar'
                      : 'Favorilere ekle',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    PlayerProcess.toggleFavorite(_currentSong);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        PlayerProcess.isFavorite(_currentSong)
                            ? 'Favorilere eklendi'
                            : 'Favorilerden çıkarıldı',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.album, color: Colors.white),
                title: Text(
                  'Albüme git',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Albüm sayfası (yapım aşamasında)')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(
                  'Sanatçıya git',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Sanatçı id'si olmadığı için mock veriden artist objesi oluşturuluyor
                  final artist = MockSongService.getArtists().firstWhere(
                    (a) => a.name == _currentSong.artist,
                    orElse: () => MockSongService.getArtists()[0],
                  );
                  Navigator.pushNamed(
                    context,
                    '/artist_detail',
                    arguments: artist,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.white),
                title: Text('Paylaş', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Şarkı paylaşıldı (simülasyon)')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddToPlaylistDialog() {
    final playlists = _playlistManager.getUserPlaylists();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Çalma Listesine Ekle',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: playlists.length + 1, // +1 for "New Playlist" option
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF1DB954),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                    title: Text(
                      'Yeni Çalma Listesi',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showCreatePlaylistDialog();
                    },
                  );
                }

                final playlist = playlists[index - 1];
                return ListTile(
                  leading: Image.network(
                    playlist.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    playlist.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${playlist.songs.length} şarkı',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    final added = _playlistManager.addSongToPlaylist(
                      playlist.id,
                      _currentSong,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          added
                              ? '${playlist.name} listesine eklendi'
                              : 'Şarkı zaten bu çalma listesinde',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showCreatePlaylistDialog() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Yeni Çalma Listesi',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Çalma listesi adı',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1DB954)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  final newPlaylist = _playlistManager.createPlaylist(
                    name: _controller.text.trim(),
                  );
                  _playlistManager.addSongToPlaylist(
                    newPlaylist.id,
                    _currentSong,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${_controller.text} çalma listesi oluşturuldu ve şarkı eklendi',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1DB954),
              ),
              child: Text('Oluştur'),
            ),
          ],
        );
      },
    );
  }
}
