import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sweet_peach_fe/apis/api_const.dart';
import '../models/image_chapter.dart';

class ChapterService {
  Future<List<ImageChapter>> getImagesChapterByChapterId(int chapterId) async {
    final url = '${ApiConst.baseUrl}api/chapterImages/chapter/${chapterId}'; // Thay thế bằng URL API thực tế của bạn
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ImageChapter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images for chapter');
    }
  }
  Future<void> incrementViewCount(int id) async {
    final String apiUrl = '${ApiConst.baseUrl}api/chapters/view/$id';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('View count incremented successfully');
      } else {
        print('Failed to increment view count. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while incrementing view count: $e');
    }
  }
}
