import 'dart:convert';

import '../models/comic.dart';
import '../models/user_follow_comic.dart';
import 'api_const.dart';
import 'auth_service.dart';
import 'comic_service.dart';
import 'package:http/http.dart' as http;

class FollowService{
  final comicService= ComicService();
  final authService = AuthService();
  Future<List<Comic>>getFollowComic() async {
    final userId = (await authService.getUserId()) ;
    print('userId: ${userId}');
    if (userId != null) {
      final apiUrl = '${ApiConst.baseUrl}api/comics/${userId}/followed-comics';
      return ComicService.fetchData(apiUrl);
    }
    else {
        throw Exception('Failed to get follow');
    }
  }
  static final String baseUrl = '${ApiConst.baseUrl}';

  Future<UserFollowedComics> followComic(int userId, int comicId) async {

    final response = await http.post(
      Uri.parse('${baseUrl}api/user/${userId}/follow/$comicId'),
    );

    if (response.statusCode == 200) {
      return UserFollowedComics.fromJson(jsonDecode(response.body));

    } else {
      throw Exception('Failed to follow comic: ${response.statusCode}');
    }
  }

  Future<void> unfollowComic(int userId, int comicId) async {
    final response = await http.delete(
      Uri.parse('${baseUrl}api/user/$userId/unfollow/$comicId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to unfollow comic: ${response.statusCode}');
    }
  }
}