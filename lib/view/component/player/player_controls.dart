import 'package:flutter/material.dart';

class ShuffleControl extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const ShuffleControl({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ShuffleControlState createState() => _ShuffleControlState();
}

class _ShuffleControlState extends State<ShuffleControl> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.shuffle,
        color: _isEnabled ? Color(0xFF1DB954) : Colors.white,
      ),
      onPressed: () {
        setState(() {
          _isEnabled = !_isEnabled;
        });
        widget.onChanged(_isEnabled);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEnabled ? 'Karıştırma açık' : 'Karıştırma kapalı'),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }
}

class RepeatControl extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const RepeatControl({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _RepeatControlState createState() => _RepeatControlState();
}

class _RepeatControlState extends State<RepeatControl> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.repeat,
        color: _isEnabled ? Color(0xFF1DB954) : Colors.white,
      ),
      onPressed: () {
        setState(() {
          _isEnabled = !_isEnabled;
        });
        widget.onChanged(_isEnabled);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEnabled ? 'Tekrarlama açık' : 'Tekrarlama kapalı'),
            duration: Duration(seconds: 1),
          ),
        );
      },
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const FavoriteButton({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialValue;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _sizeAnimation.value,
          child: IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Color(0xFF1DB954) : Colors.white,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
                if (_isFavorite) {
                  _controller.forward(from: 0.0);
                }
              });
              widget.onChanged(_isFavorite);
            },
          ),
        );
      },
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;
  final AnimationController controller;

  const PlayPauseButton({
    Key? key,
    required this.isPlaying,
    required this.onPressed,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: IconButton(
        iconSize: 40,
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: controller,
          color: Colors.black,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
