import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double currentPosition;
  final double totalDuration;
  final ValueChanged<double> onChanged;
  final String Function(double) formatDuration;

  const ProgressBar({
    Key? key,
    required this.currentPosition,
    required this.totalDuration,
    required this.onChanged,
    required this.formatDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
          ),
          child: Slider(
            value: currentPosition.clamp(0, totalDuration),
            min: 0,
            max: totalDuration,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(currentPosition),
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                formatDuration(totalDuration),
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
