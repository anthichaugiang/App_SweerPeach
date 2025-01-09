class ReadingHistory {
  final int comicId;
  final int chapterId;

  ReadingHistory(this.comicId, this.chapterId);

  Map<String, dynamic> toJson() {
    return {
      'comicId': comicId,
      'chapterId': chapterId,
    };
  }

  factory ReadingHistory.fromJson(Map<String, dynamic> json) {
    return ReadingHistory(
      json['comicId'] as int,
      json['chapterId'] as int,
    );
  }
}
