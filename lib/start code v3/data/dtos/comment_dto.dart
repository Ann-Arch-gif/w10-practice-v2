import '../../model/comment/comment.dart';

class CommentDto {
  static const String artistIdKey = 'artistId';
  static const String textKey = 'text';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    assert(json[artistIdKey] is String);
    assert(json[textKey] is String);

    return Comment(
      id: id,
      artistId: json[artistIdKey],
      text: json[textKey],
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      artistIdKey: comment.artistId,
      textKey: comment.text,
    };
  }
}
