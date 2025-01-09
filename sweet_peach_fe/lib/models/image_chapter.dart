class ImageChapter {
  final int id;
  final String imagePath;

  ImageChapter({required this.id, required this.imagePath});

  factory ImageChapter.fromJson(Map<String, dynamic> json) {
    return ImageChapter(
      id: json['id'],
      imagePath: json['imagePath'],
    );
  }
}
