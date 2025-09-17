import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../model/song.dart';
import 'playlist_manager.dart';

/// Şarkı çalma durumunu yöneten servis
class PlayerService extends ChangeNotifier {
  static final PlayerService _instance = PlayerService._internal();
  final PlaylistManager _playlistManager = PlaylistManager();
  AudioPlayer? _audioPlayer;

  factory PlayerService() {
    return _instance;
  }

  PlayerService._internal() {
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      _audioPlayer = AudioPlayer();

      // Varsayılan ses oturumu yapılandırmasını ayarla
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.speech());
    } catch (e) {
      print('Ses oynatıcıyı başlatma hatası: $e');
      // Bir hata oluşursa, simüle edilmiş oynatma ile devam edeceğiz
    }
  }

  Song? _currentSong;
  bool _isPlaying = false;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  AudioPlayer? get audioPlayer => _audioPlayer;

  Future<void> playSong(Song song, {bool autoPlay = false}) async {
    _currentSong = song;

    // Eğer şarkının bir ses URL'i varsa ve audio player hazırsa onu hazırla
    if (song.audioUrl.isNotEmpty && _audioPlayer != null) {
      try {
        await _audioPlayer?.stop();
        await _audioPlayer?.setUrl(song.audioUrl);

        // Sadece autoPlay true ise çal
        if (autoPlay) {
          await _audioPlayer?.play();
          _isPlaying = true;
        } else {
          _isPlaying = false;
        }
      } catch (e) {
        print('Ses çalma hatası: $e');
        _isPlaying = false;
      }
    } else {
      // URL yoksa simüle et
      _isPlaying = true;
    }

    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_currentSong != null) {
      if (_isPlaying) {
        if (_currentSong!.audioUrl.isNotEmpty && _audioPlayer != null) {
          await _audioPlayer?.pause();
        }
        _isPlaying = false;
      } else {
        if (_currentSong!.audioUrl.isNotEmpty && _audioPlayer != null) {
          await _audioPlayer?.play();
        }
        _isPlaying = true;
      }
      notifyListeners();
    }
  }

  // Geriye uyumluluk için metodlar
  Future<void> pauseSong() async {
    if (_isPlaying) {
      if (_currentSong?.audioUrl.isNotEmpty == true && _audioPlayer != null) {
        await _audioPlayer?.pause();
      }
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> resumeSong() async {
    if (_currentSong != null && !_isPlaying) {
      if (_currentSong!.audioUrl.isNotEmpty && _audioPlayer != null) {
        await _audioPlayer?.play();
      }
      _isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> stopSong() async {
    if (_currentSong?.audioUrl.isNotEmpty == true && _audioPlayer != null) {
      await _audioPlayer?.stop();
    }
    _currentSong = null;
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> playNextSong({bool autoPlay = false}) async {
    final nextSong = _playlistManager.nextSong();
    if (nextSong != null) {
      await playSong(nextSong, autoPlay: autoPlay);
    }
  }

  Future<void> playPreviousSong({bool autoPlay = false}) async {
    final previousSong = _playlistManager.previousSong();
    if (previousSong != null) {
      await playSong(previousSong, autoPlay: autoPlay);
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}
