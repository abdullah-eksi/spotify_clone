import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onNotificationsTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onSettingsTap;

  const HomeAppBar({
    Key? key,
    required this.onNotificationsTap,
    required this.onHistoryTap,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Günaydın',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined),
          onPressed: onNotificationsTap,
        ),
        IconButton(icon: Icon(Icons.history), onPressed: onHistoryTap),
        IconButton(
          icon: Icon(Icons.settings_outlined),
          onPressed: onSettingsTap,
        ),
      ],
    );
  }
}
