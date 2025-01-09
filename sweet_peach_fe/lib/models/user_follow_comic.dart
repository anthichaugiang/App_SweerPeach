class UserFollowedComics {
  final int userId;
  final int comicId;

  UserFollowedComics({
    required this.userId,
    required this.comicId,

  });

  factory UserFollowedComics.fromJson(Map<String, dynamic> json) {
    return UserFollowedComics(
      userId: json['userId'],
      comicId: json['comicId'],

    );
  }
}