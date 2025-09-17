import 'package:flutter/material.dart';

class Category {
  final String name;
  final Color color;
  final Color secondColor;
  final IconData icon;

  Category({
    required this.name,
    required this.color,
    required this.secondColor,
    required this.icon,
  });
}

class SearchCategory {
  static List<Category> getCategories() {
    return [
      Category(
        name: 'Podcasts',
        color: Colors.purple,
        secondColor: Colors.purpleAccent,
        icon: Icons.mic,
      ),
      Category(
        name: 'Live Events',
        color: Colors.red,
        secondColor: Colors.redAccent,
        icon: Icons.event,
      ),
      Category(
        name: 'Made For You',
        color: Colors.blue,
        secondColor: Colors.blueAccent,
        icon: Icons.person,
      ),
      Category(
        name: 'New Releases',
        color: Colors.green,
        secondColor: Colors.greenAccent,
        icon: Icons.new_releases,
      ),
      Category(
        name: 'Pop',
        color: Colors.pink,
        secondColor: Colors.pinkAccent,
        icon: Icons.music_note,
      ),
      Category(
        name: 'Hip-Hop',
        color: Colors.orange,
        secondColor: Colors.orangeAccent,
        icon: Icons.headphones,
      ),
      Category(
        name: 'Rock',
        color: Colors.teal,
        secondColor: Colors.tealAccent,
        icon: Icons.music_note,
      ),
      Category(
        name: 'Dance/Electronic',
        color: Colors.deepPurple,
        secondColor: Colors.deepPurpleAccent,
        icon: Icons.flash_on,
      ),
    ];
  }
}
