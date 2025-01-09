class Chapter {
  final int id;
  final String title;
  final int chapterNumber;
  final int viewCount;
  final DateTime updatedAt;
  final bool deleted;

  Chapter({
    required this.id,
    required this.title,
    required this.chapterNumber,
    required this.viewCount,
    required this.updatedAt,
    required this.deleted,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      chapterNumber: json['chapterNumber'],
      viewCount: json['viewCount'],
      updatedAt: DateTime.parse(json['updatedAt']),
      deleted: json['deleted'],
    );
  }
}