import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../theme/theme.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/song/comment_tile.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/artist_detail_view_model.dart';

class ArtistDetailContent extends StatefulWidget {
  const ArtistDetailContent({super.key});

  @override
  State<ArtistDetailContent> createState() => _ArtistDetailContentState();
}

class _ArtistDetailContentState extends State<ArtistDetailContent> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment(ArtistDetailViewModel vm) {
    final text = _commentController.text;
    if (text.trim().isEmpty) return;
    vm.addComment(text);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ArtistDetailViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(vm.artist.name, style: AppTextStyles.title),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.neutralDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Artist header
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(vm.artist.imageUrl.toString()),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(vm.artist.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text(vm.artist.genre,
                style: TextStyle(color: AppColors.neutralLight, fontSize: 16)),
          ),
          SizedBox(height: 24),

          // Songs section
          Text('Songs', style: AppTextStyles.title),
          SizedBox(height: 8),
          _buildSongsSection(vm),
          SizedBox(height: 24),

          // Comments section
          Text('Comments', style: AppTextStyles.title),
          SizedBox(height: 8),
          _buildCommentsSection(vm),
          SizedBox(height: 100), // space for bottom bar
        ],
      ),
      bottomSheet: _buildCommentForm(vm),
    );
  }

  Widget _buildSongsSection(ArtistDetailViewModel vm) {
    final asyncValue = vm.songsValue;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Text('Error loading songs: ${asyncValue.error}',
            style: TextStyle(color: Colors.red));
      case AsyncValueState.success:
        final List<Song> songs = asyncValue.data!;
        if (songs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No songs yet.',
                style: TextStyle(color: AppColors.neutralLight)),
          );
        }
        return Column(
          children: songs.map((s) => SongTile(song: s)).toList(),
        );
    }
  }

  Widget _buildCommentsSection(ArtistDetailViewModel vm) {
    final asyncValue = vm.commentsValue;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Text('Error loading comments: ${asyncValue.error}',
            style: TextStyle(color: Colors.red));
      case AsyncValueState.success:
        final List<Comment> comments = asyncValue.data!;
        if (comments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No comments yet. Be the first!',
                style: TextStyle(color: AppColors.neutralLight)),
          );
        }
        return Column(
          children: comments.map((c) => CommentTile(comment: c)).toList(),
        );
    }
  }

  Widget _buildCommentForm(ArtistDetailViewModel vm) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _submitComment(vm),
            child: Text('Post'),
          ),
        ],
      ),
    );
  }
}
