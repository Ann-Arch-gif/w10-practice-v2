import 'package:flutter/material.dart';

import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artist,
  }) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Fetch songs and comments in parallel
    await Future.wait([
      _fetchSongs(),
      _fetchComments(),
    ]);
  }

  Future<void> _fetchSongs() async {
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final songs = await artistRepository.fetchArtistSongs(artist.id);
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> _fetchComments() async {
    commentsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final comments = await artistRepository.fetchArtistComments(artist.id);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> addComment(String text) async {
    if (text.trim().isEmpty) return;

    final comment = Comment(
      id: '',
      artistId: artist.id,
      text: text.trim(),
    );

    try {
      await artistRepository.postComment(comment);

      // Update local state immediately
      final currentList = commentsValue.data ?? [];
      commentsValue = AsyncValue.success([...currentList, comment]);
      notifyListeners();
    } catch (e) {
      commentsValue = AsyncValue.error(e);
      notifyListeners();
    }
  }
}
