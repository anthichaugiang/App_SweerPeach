class CommentRequest {
  final int chapterId;
  final int comicId;
  final String content;
  final int  userId;
  CommentRequest(this.userId, {
    required this.chapterId,
    required this.comicId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'comicId': comicId,
      'content': content,
      'comicId':comicId
    };
  }
}
