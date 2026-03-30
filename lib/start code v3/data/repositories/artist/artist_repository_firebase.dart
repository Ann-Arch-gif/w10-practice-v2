import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/comment_dto.dart';
import '../../dtos/song_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  static const String _baseHost =
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri artistsUri = Uri.https(_baseHost, '/artists.json');

  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    // 1. Return cache if available
    if (!forceFetch && _cachedArtists != null) return _cachedArtists!;

    // 2. Otherwise fetch from API
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in songJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }

      // 3. Store in memory
      _cachedArtists = result;
      return _cachedArtists!;
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return null;
  }

  @override
  Future<List<Song>> fetchArtistSongs(String artistId) async {
    final uri = Uri.https(
      _baseHost,
      '/songs.json',
      {'orderBy': '"artistId"', 'equalTo': '"$artistId"'},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded == null) return [];

      final Map<String, dynamic> songsJson = decoded;
      return songsJson.entries
          .map((e) => SongDto.fromJson(e.key, e.value))
          .toList();
    } else {
      throw Exception('Failed to fetch songs for artist $artistId');
    }
  }

  @override
  Future<List<Comment>> fetchArtistComments(String artistId) async {
    final uri = Uri.https(
      _baseHost,
      '/comments.json',
      {'orderBy': '"artistId"', 'equalTo': '"$artistId"'},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded == null) return [];

      final Map<String, dynamic> commentsJson = decoded;
      return commentsJson.entries
          .map((e) => CommentDto.fromJson(e.key, e.value))
          .toList();
    } else {
      throw Exception('Failed to fetch comments for artist $artistId');
    }
  }

  @override
  Future<void> postComment(Comment comment) async {
    final uri = Uri.https(_baseHost, '/comments.json');

    final response = await http.post(
      uri,
      body: json.encode(CommentDto.toJson(comment)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post comment');
    }
  }
}
