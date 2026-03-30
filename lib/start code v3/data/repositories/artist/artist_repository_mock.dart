import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import 'artist_repository.dart';

class ArtistRepositoryMock implements ArtistRepository {
  final List<Artist> _artists = [];
  final List<Song> _songs = [];
  final List<Comment> _comments = [];
  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    // 1. Return cache if available
    if (!forceFetch && _cachedArtists != null) return _cachedArtists!;

    // 2. Otherwise fetch (simulated delay)
    return Future.delayed(Duration(seconds: 4), () {
      // 3. Store in memory
      _cachedArtists = _artists;
      return _cachedArtists!;
    });
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _artists.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception('No artist with id $id in the database'),
      );
    });
  }

  @override
  Future<List<Song>> fetchArtistSongs(String artistId) async {
    return Future.delayed(Duration(seconds: 1), () {
      return _songs.where((s) => s.artistId == artistId).toList();
    });
  }

  @override
  Future<List<Comment>> fetchArtistComments(String artistId) async {
    return Future.delayed(Duration(seconds: 1), () {
      return _comments.where((c) => c.artistId == artistId).toList();
    });
  }

  @override
  Future<void> postComment(Comment comment) async {
    return Future.delayed(Duration(seconds: 1), () {
      _comments.add(comment);
    });
  }
}
