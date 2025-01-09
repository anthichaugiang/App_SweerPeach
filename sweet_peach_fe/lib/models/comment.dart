class Comment {
  final int userId;
  final String username;
  final String avatar;
  final int comicId;
  final int chapterId;
  final String content;
  final String createdAt;

  Comment({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.comicId,
    required this.chapterId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'],
      username: json['username'],
      avatar: json['avatar'],
      comicId: json['comicId'],
      chapterId: json['chapterId'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }
}
