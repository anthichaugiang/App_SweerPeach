class Comic {
  final int comicId;
  final String title;
  final String imageUrl;
  final String lastChapter;
  final String timeSinceAdded;
  final String status;
  final int views;
  final int follows;
  final List<String>? genres;

  Comic({
    required this.comicId,
    required this.title,
    required this.imageUrl,
    required this.lastChapter ,
    required this.timeSinceAdded,
    required this.status,
    required this.views,
    required this.follows,
    required this.genres,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    List<String> genres = [];
    if (json['genres'] != null) {
      genres = List<String>.from(json['genres'].map((genreJson) => genreJson['name']));
    }
    return Comic(
      comicId: json['id'],
      title: json['title'],
      imageUrl: json['coverImage'],
      lastChapter: json['latestChapterTitle'],
      timeSinceAdded: json['timeSinceLastUpdate'],
      status:json['status'],
      views: json['viewCount'],
      follows: json['followCount'],
      genres: genres,
    );
  }
}

//List<Comic> comicList = jsonData.map((json) => Comic.fromJson(json)).toList();