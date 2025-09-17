import 'package:flutter/material.dart';
import '../../../model/song.dart';
import '../../../service/player_service.dart';

class MiniPlayer extends StatefulWidget {
  final Song currentSong;
  final VoidCallback onTap;

  const MiniPlayer({required this.currentSong, required this.onTap, Key? key})
    : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _playPauseController;
  final PlayerService _playerService = PlayerService();

  @override
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Gerçek oynatıcı durumuyla senkronize et
    if (_playerService.isPlaying) {
      _playPauseController.forward();
    } else {
      _playPauseController.reverse();
    }
  }

  @override
  void didUpdateWidget(MiniPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Şarkı değiştiğinde, oynatma düğmesini doğru durumu gösterecek şekilde sıfırla
    if (oldWidget.currentSong.id != widget.currentSong.id) {
      if (_playerService.isPlaying) {
        _playPauseController.forward();
      } else {
        _playPauseController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    // Oynatılacak mı yoksa durdurulacak mı tespit et
    final willBePlaying = !_playerService.isPlaying;

    // Asenkron işlemden önce UI'ı hemen güncelle
    if (willBePlaying) {
      _playPauseController.forward();
      _showPlayingSnackBar();
    } else {
      _playPauseController.reverse();
    }

    // UI güncellemesini zorla
    setState(() {});

    // Sonra asıl geçiş işlemini gerçekleştir (asenkron)
    await _playerService.togglePlayPause();

    // Uç durumlar için son kontrol
    if (mounted) {
      // Kontrolörün doğru pozisyonda olduğundan emin ol
      if (_playerService.isPlaying &&
          _playPauseController.status != AnimationStatus.completed) {
        _playPauseController.forward();
      } else if (!_playerService.isPlaying &&
          _playPauseController.status != AnimationStatus.dismissed) {
        _playPauseController.reverse();
      }

      // Gerekirse UI'ı güncelle
      setState(() {});
    }
  }

  void _playPreviousSong() {
    _playerService.playPreviousSong();
    setState(() {});
    if (_playerService.currentSong != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Önceki şarkı: ${_playerService.currentSong!.title}'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _playNextSong() {
    _playerService.playNextSong();
    setState(() {});
    if (_playerService.currentSong != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sonraki şarkı: ${_playerService.currentSong!.title}'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showPlayingSnackBar() {
    // Sadece gerçekten çalacaksa oynatma mesajını göster
    if (!_playerService.isPlaying) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Çalınıyor: ${widget.currentSong.title} - ${widget.currentSong.artist}',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Color(0xFF282828),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  widget.currentSong.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.currentSong.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.currentSong.artist,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Bağlı cihazlar ikonu
            IconButton(
              icon: Icon(Icons.devices, color: Colors.white),
              iconSize: 22,
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Connect to a device')));
              },
            ),
            // Önceki parça düğmesi
            IconButton(
              icon: Icon(Icons.skip_previous, color: Colors.white),
              iconSize: 22,
              onPressed: () {
                _playPreviousSong();
              },
            ),
            // Play/Pause button
            IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _playPauseController,
                color: Colors.white,
              ),
              iconSize: 30,
              onPressed: _togglePlayPause,
            ),
            // Sonraki parça düğmesi
            IconButton(
              icon: Icon(Icons.skip_next, color: Colors.white),
              iconSize: 22,
              onPressed: () {
                _playNextSong();
              },
            ),
          ],
        ),
      ),
    );
  }
}
