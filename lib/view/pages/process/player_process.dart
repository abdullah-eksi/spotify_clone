import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../model/song.dart';
import '../../../service/mock_song_service.dart';
import '../../../service/favorite_service.dart';
import '../../../service/playlist_manager.dart';
import '../../../service/player_service.dart';

class PlayerProcess {
  // Favori durumunu kontrol et
  static bool isFavorite(Song song) {
    return FavoriteService.isSongFavorite(song.id);
  }

  // Favorilere ekle/çıkar
  static bool toggleFavorite(Song song) {
    if (FavoriteService.isSongFavorite(song.id)) {
      FavoriteService.removeSongFromFavorites(song.id);
      return false;
    } else {
      FavoriteService.addSongToFavorites(song.id);
      return true;
    }
  }

  // Şarkıyı oynat/duraklat
  static Future<bool> togglePlayPause(PlayerService playerService) async {
    try {
      if (playerService.isPlaying) {
        // Pause as quickly as possible
        await playerService.pauseSong();
        return false;
      } else {
        // Resume playback
        await playerService.resumeSong();
        return true;
      }
    } catch (e) {
      print('Error in togglePlayPause: $e');
      // Return the current state in case of error
      return playerService.isPlaying;
    }
  }

  // Sonraki şarkıya geç
  static Future<Song?> playNextSong(
    PlaylistManager playlistManager,
    PlayerService playerService,
  ) async {
    // Önceki çalmayı durdur ve sonraki şarkıya geç
    if (playerService.isPlaying) {
      await playerService.pauseSong();
    }
    await playerService.playNextSong(autoPlay: false);
    return playlistManager.getCurrentSong();
  }

  // Önceki şarkıya geç
  static Future<Song?> playPreviousSong(
    PlaylistManager playlistManager,
    PlayerService playerService,
  ) async {
    // Önceki çalmayı durdur ve önceki şarkıya geç
    if (playerService.isPlaying) {
      await playerService.pauseSong();
    }
    await playerService.playPreviousSong(autoPlay: false);
    return playlistManager.getCurrentSong();
  }

  // Karıştırma durumunu değiştir
  static bool toggleShuffle(PlaylistManager playlistManager) {
    bool currentMode = playlistManager.isShuffleMode();
    playlistManager.setShuffleMode(!currentMode);
    return !currentMode;
  }

  // Tekrarlama durumunu değiştir
  // Not: PlaylistManager'da repeat modunu yönetecek bir metot bulunmadığından
  // şimdilik bu metot bir simülasyon döndürsün - gerçek implementasyon geliştirilmeli
  static bool toggleRepeat(PlaylistManager playlistManager) {
    // Şimdilik sadece true döndür
    // Gerçek uygulama PlaylistManager'da repeat modu eklendikten sonra güncellenecek
    return true;
  }

  // İlerleme çubuğunu oluştur
  static Widget buildProgressBar({
    required double currentPosition,
    required double totalDuration,
    required Function(double) onSeek,
  }) {
    return Column(
      children: [
        Slider(
          value: currentPosition,
          min: 0,
          max: totalDuration,
          activeColor: Colors.white,
          inactiveColor: Colors.grey[800],
          onChanged: onSeek,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(currentPosition),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                _formatDuration(totalDuration),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Müzik kontrol butonlarını oluştur
  static Widget buildPlayerControls({
    required bool isPlaying,
    required VoidCallback onPrevious,
    required VoidCallback onPlayPause,
    required VoidCallback onNext,
    required bool isShuffle,
    required bool isRepeat,
    required VoidCallback onShuffleToggle,
    required VoidCallback onRepeatToggle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            isShuffle ? Icons.shuffle : Icons.shuffle,
            color: isShuffle ? Colors.green : Colors.grey,
          ),
          onPressed: onShuffleToggle,
        ),
        IconButton(
          icon: Icon(Icons.skip_previous, color: Colors.white, size: 36),
          onPressed: onPrevious,
        ),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
              size: 36,
            ),
            onPressed: onPlayPause,
          ),
        ),
        IconButton(
          icon: Icon(Icons.skip_next, color: Colors.white, size: 36),
          onPressed: onNext,
        ),
        IconButton(
          icon: Icon(
            isRepeat ? Icons.repeat_one : Icons.repeat,
            color: isRepeat ? Colors.green : Colors.grey,
          ),
          onPressed: onRepeatToggle,
        ),
      ],
    );
  }

  // Zamanlayıcı başlat
  static Timer startPlaybackTimer({
    required void Function(double) onTick,
    required double currentPosition,
    required double totalDuration,
    required bool isPlaying,
    required void Function() onComplete,
  }) {
    if (isPlaying) {
      return Timer.periodic(Duration(seconds: 1), (timer) {
        if (currentPosition < totalDuration) {
          onTick(currentPosition + 1);
        } else {
          timer.cancel();
          onComplete();
        }
      });
    } else {
      return Timer(Duration.zero, () {});
    }
  }

  // İlgili şarkılar önerisi oluştur
  static List<Song> getRelatedSongs(Song currentSong) {
    // Aynı sanatçıdan ya da aynı albümden şarkılar bul
    return MockSongService.getSongs()
        .where(
          (song) =>
              (song.artist == currentSong.artist ||
                  song.album == currentSong.album) &&
              song.id != currentSong.id,
        )
        .take(5)
        .toList();
  }

  // MS cinsinden süreyi formatla
  static String _formatDuration(double seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toInt().toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  // MS cinsinden süreyi saniyeye çevir
  static double msToSeconds(int ms) {
    return ms / 1000;
  }

  // Saniyeyi MS'ye çevir
  static int secondsToMs(double seconds) {
    return (seconds * 1000).toInt();
  }
}
