import 'package:flutter/material.dart';
import 'player_controls.dart';

class PlaybackControls extends StatelessWidget {
  final bool isShuffle;
  final bool isRepeat;
  final VoidCallback onShuffleToggle;
  final VoidCallback onRepeatToggle;
  final VoidCallback onPreviousTrack;
  final VoidCallback onPlayPause;
  final VoidCallback onNextTrack;
  final AnimationController playPauseController;

  const PlaybackControls({
    Key? key,
    required this.isShuffle,
    required this.isRepeat,
    required this.onShuffleToggle,
    required this.onRepeatToggle,
    required this.onPreviousTrack,
    required this.onPlayPause,
    required this.onNextTrack,
    required this.playPauseController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ShuffleControl(
          initialValue: isShuffle,
          onChanged: (value) => onShuffleToggle(),
        ),
        IconButton(
          icon: Icon(Icons.skip_previous, color: Colors.white, size: 36),
          onPressed: onPreviousTrack,
        ),
        PlayPauseButton(
          isPlaying: playPauseController.status == AnimationStatus.completed,
          onPressed: onPlayPause,
          controller: playPauseController,
        ),
        IconButton(
          icon: Icon(Icons.skip_next, color: Colors.white, size: 36),
          onPressed: onNextTrack,
        ),
        RepeatControl(
          initialValue: isRepeat,
          onChanged: (value) => onRepeatToggle(),
        ),
      ],
    );
  }
}
