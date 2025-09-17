import 'package:flutter/material.dart';
import '../../../model/album.dart';
import '../../../model/song.dart';
import '../../../service/mock_song_service.dart';
import '../player_page.dart';

class AlbumProcess {
  // Albüme ait şarkıları getir
  static List<Song> getSongsForAlbum(Album album) {
    return MockSongService.getSongs()
        .where(
          (song) =>
              song.album.toLowerCase() == album.name.toLowerCase() &&
              song.artist.toLowerCase() == album.artist.toLowerCase(),
        )
        .toList();
  }

  // Toplam süreyi hesapla
  static String calculateTotalDuration(List<Song> songs) {
    int totalDurationInMs = 0;
    for (var song in songs) {
      totalDurationInMs += song.durationMs;
    }

    final totalDurationInSeconds = totalDurationInMs ~/ 1000;
    final hours = totalDurationInSeconds ~/ 3600;
    final minutes = (totalDurationInSeconds % 3600) ~/ 60;
    final seconds = totalDurationInSeconds % 60;

    if (hours > 0) {
      return '$hours saat ${minutes} dakika';
    } else {
      return '$minutes dakika ${seconds > 0 ? '$seconds saniye' : ''}';
    }
  }

  // Albüm meta bilgilerini oluştur
  static Widget buildAlbumMeta(Album album, List<Song> songs) {
    final totalDuration = calculateTotalDuration(songs);
    final year = album.year.toString();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  album.imageUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      album.artist,
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(year, style: TextStyle(color: Colors.grey)),
              SizedBox(width: 16),
              Icon(Icons.timer, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(totalDuration, style: TextStyle(color: Colors.grey)),
              SizedBox(width: 16),
              Icon(Icons.music_note, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                '${songs.length} şarkı',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MS cinsinden süreyi formatla
  static String formatDuration(int durationMs) {
    final durationInSeconds = durationMs ~/ 1000;
    final minutes = durationInSeconds ~/ 60;
    final seconds = durationInSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // Şarkı listesini oluştur
  static Widget buildSongsList(List<Song> songs, BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          leading: Text(
            '${index + 1}',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          title: Text(
            song.title,
            style: TextStyle(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.artist,
            style: TextStyle(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            formatDuration(song.durationMs),
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerPage(song: song)),
            );
          },
        );
      },
    );
  }
}
