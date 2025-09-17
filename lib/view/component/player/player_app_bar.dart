import 'package:flutter/material.dart';

class PlayerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String albumName;
  final VoidCallback onBackTap;
  final VoidCallback onMoreTap;

  const PlayerAppBar({
    Key? key,
    required this.albumName,
    required this.onBackTap,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.keyboard_arrow_down),
        onPressed: onBackTap,
      ),
      title: Column(
        children: [
          Text(
            'PLAYING FROM PLAYLIST',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            albumName,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: onMoreTap)],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
