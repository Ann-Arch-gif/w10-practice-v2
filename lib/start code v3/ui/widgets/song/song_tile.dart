import 'package:flutter/material.dart';

import '../../../model/songs/song.dart';

class SongTile extends StatelessWidget {
  const SongTile({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(song.imageUrl.toString()),
          ),
          title: Text(song.title),
          subtitle: Text('${song.duration.inMinutes} mins'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, color: Colors.blue, size: 16),
              SizedBox(width: 4),
              Text('${song.likes}', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
