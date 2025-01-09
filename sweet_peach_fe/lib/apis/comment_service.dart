import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/dtos/comment_request.dart';

import '../models/comment.dart';
import 'auth_service.dart';

class CommentService {

  Future<List<Comment>> fetchComments(int chapterId) async {
    final response = await http.get(Uri.parse('${ApiConst.baseUrl}api/comments/chapter/${chapterId}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)) ;

      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }
  Future<void> postComment(int chapterId,int comicId, String comment) async {
    final authService = AuthService();
    final int? userIdInt = await authService.getUserId();
    final String userId = userIdInt.toString();
    try {
      final response = await http.post(
        Uri.parse('${ApiConst.baseUrl}api/comments/add'),
        body: jsonEncode({
          'chapterId': chapterId,
          'userId': userId,
          'content': comment,
          'comicId':comicId,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print("sucsess comment");
      } else {
        throw Exception('Failed to post comment');
      }
    } catch (error) {
      print('Error posting comment: $error');
      throw error;
    }
  }
}
