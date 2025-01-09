import '../models/Chapter.dart';
import '../models/genre.dart';

class ComicDto {
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final int viewCount;
  final int followCount;
  final List<Chapter> chapters;
  final List<String> genres;

  ComicDto({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.viewCount,
    required this.followCount,
    required this.chapters,
    required this.genres,
  });

  factory ComicDto.fromJson(Map<String, dynamic> json) {
    List<Chapter> chapters = [];
    if (json['chapters'] != null) {
      chapters = List<Chapter>.from(json['chapters'].map((chapterJson) => Chapter.fromJson(chapterJson)));
    }

    List<String> genres = [];
    if (json['genres'] != null) {
      genres = List<String>.from(json['genres'].map((genreJson) => genreJson['name']));
    }

    return ComicDto(
      id: json['id'],
      title: json['title'],
      coverImage: json['coverImage'],
      description: json['description'],
      viewCount: json['viewCount'],
      followCount: json['followCount'],
      chapters: chapters,
      genres: genres,
    );
  }
}
