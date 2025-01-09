import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sweet_peach_fe/apis/api_const.dart';

import '../dtos/comic_dto.dart';
import '../models/comic.dart';

class ComicService {
  // Hàm gọi API để lấy thông tin chi tiết của một truyện
  Future<ComicDto> fetchComic(int comicId) async {
    final apiUrl = '${ApiConst.baseUrl}api/comics/$comicId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return ComicDto.fromJson(jsonData);
      } else {
        throw Exception('Failed to load comic');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Hàm gọi API chung để lấy danh sách truyện dựa trên URL API được cung cấp
  static Future<List<Comic>> fetchData(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));

        final List<Comic> comics = jsonData.map((data) {
          return Comic.fromJson(data);
        }).toList();
        return comics;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Hàm gọi API để lấy danh sách truyện mới nhất
  static Future<List<Comic>> fetchNewStories(int limit) async {
    final apiUrl = '${ApiConst.baseUrl}api/comics/newest1?limit=${limit}';
    return await fetchData(apiUrl);
  }

  // Hàm gọi API để lấy danh sách truyện được đề xuất
  static Future<List<Comic>> fetchRecomComic(int limit) async {
    final apiUrl = '${ApiConst.baseUrl}api/comics/hot1?period=week&limithot=${limit}';
    return await fetchData(apiUrl);
  }

  // Hàm gọi API để lấy danh sách truyện theo BXH
  static Future<List<Comic>> fetchRankingComic(String peroid, int limit) async {
    final apiUrl = '${ApiConst.baseUrl}api/comics/hot1?period=${peroid}&limithot=${limit}';
    return await fetchData(apiUrl);
  }

  // Hàm gọi API để lấy danh sách tất cả truyện
  static Future<List<Comic>> fetchAllComic() async {
    final apiUrl = '${ApiConst.baseUrl}api/comics/getalls';
    print("call:${apiUrl}");
    return await fetchData(apiUrl);
  }
  static Future<List<Comic>> fetchComicByGenre(int genreId) async {
    final apiUrl = '${ApiConst.baseUrl}api/comics/genre1/${genreId}';
    print(apiUrl);
    return await fetchData(apiUrl);
  }
  // Hàm sử dụng để lấy dữ liệu truyện dựa trên loại danh mục
  static Future<List<Comic>> fetchComicData(String category,{String? period, int? genreId}) async {
    List<Comic> listComic = [];
    try {
      switch (category) {
        case 'all':
          listComic = await fetchAllComic();
          print('nhận:all');
          break;
        case 'newest':
          listComic = await fetchNewStories(100);
          break;
        case 'recommended':
          listComic = await fetchRecomComic(100);
          break;
        case 'top':
          listComic = await fetchRankingComic(period ?? 'month', 100);
          break;
        case 'byGenre':
          listComic = await fetchComicByGenre(genreId!);
          print("ok:+${genreId}");
          break;
        default:
          listComic = await fetchAllComic();
          break;
      }
    } catch (e) {
      print('Error api: $e');
      print(listComic);
    }
    return listComic;
  }

}
