class TopGenreDto {
  final int genreId;
  final String genreName;
  final int totalViewCount;

  TopGenreDto({
    required this.genreId,
    required this.genreName,
    required this.totalViewCount,
  });

  factory TopGenreDto.fromJson(Map<String, dynamic> json) {
    return TopGenreDto(
      genreId: json['id'], // Chú ý đến trường này
      genreName: json['genreName'],
      totalViewCount: json['totalViewCount'],
    );
  }
}
