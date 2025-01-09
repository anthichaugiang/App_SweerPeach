import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/apis/comic_service.dart';

import '../dtos/local_history.dart';
import '../models/comic.dart';
import 'auth_service.dart';
class HistoryService {
  final comicService= ComicService();
  final authService = AuthService();
  Future<void> addReadingHistory( int comicId, int chapterId) async {
    final String apiUrladd= '${ApiConst.baseUrl}api/user/reading-history';
    final int? userIdInt = await authService.getUserId();
    final String userId = userIdInt.toString();

    if (userIdInt == null) {
      // Người dùng chưa đăng nhập, lưu tạm vào local storage
      await _saveTemporaryHistory(comicId, chapterId);
      return;
    }
    final Map<String, dynamic> requestData = {
      'userId': userId,
      'comicId': comicId,
      'chapterId': chapterId,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrladd),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 201) {
      print('Reading history added successfully.');
    } else {
      print('Failed to add reading history. Status code: ${response.statusCode}');
    }
  }
  Future<void> _saveTemporaryHistory(int comicId, int chapterId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempHistory = prefs.getStringList('tempHistory') ?? [];

    // Kiểm tra xem lịch sử đã tồn tại chưa
    bool historyExists = tempHistory.any((item) {
      Map<String, dynamic> history = jsonDecode(item);
      return history['comicId'] == comicId && history['chapterId'] == chapterId;
    });

    if (!historyExists) {
      tempHistory.add(jsonEncode({'comicId': comicId, 'chapterId': chapterId}));
      await prefs.setStringList('tempHistory', tempHistory);
      print('Temporary history saved.');
    } else {
      print('History already exists in temporary storage.');
    }
  }

  Future<List<Comic>>getReadingHistory() async {
    final userId = (await authService.getUserId()) ;
    print('userId: ${userId}');
    if (userId != null) {
      final apiUrl = '${ApiConst.baseUrl}api/comics/history/${userId}';
      return ComicService.fetchData(apiUrl);
    } else {
      final apiUrl = '${ApiConst.baseUrl}api/comics/localstorage';
      List<ReadingHistory> tempHistory = await _getTemporaryHistory();
      print(tempHistory);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(tempHistory) ,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        List<Comic> comicList = jsonData.map((json) => Comic.fromJson(json)).toList();

        return comicList;
      } else {
        throw Exception('Failed to send history to server');
      }
    }
  }

  Future<List<ReadingHistory>> _getTemporaryHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tempHistory = prefs.getStringList('tempHistory');
    if (tempHistory != null) {
      List<ReadingHistory> historyList = tempHistory
          .map((item) => ReadingHistory.fromJson(jsonDecode(item)))
          .toList();
      return historyList;
    } else {
      return [];
    }
  }


}