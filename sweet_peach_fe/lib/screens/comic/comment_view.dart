import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/apis/auth_service.dart';
import '../../apis/comment_service.dart';
import '../../models/comment.dart';
import '../user/login_screen.dart';

class CommentScreen extends StatefulWidget {
  final int chapterId;
  final int comicId;

  CommentScreen({required this.chapterId, required this.comicId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late List<Comment> comments = [];
  bool isLoading = false;
  bool isLoggedIn = false;
  TextEditingController _commentController = TextEditingController();
  final  commentService = CommentService();
  @override
  void initState() {
    super.initState();
    fetchComments(widget.chapterId);
    checkLoginStatus();
  }
  void checkLoginStatus() async {
    final authService = AuthService();
    String? token = await authService.getToken();
    print('Token: $token');
    setState(() {
      isLoggedIn = token != null;
    });
  }

  Future<void> fetchComments(int chapterId) async {
    try {
      setState(() {
        isLoading = true; // Hiển thị CircularProgressIndicator
      });

      List<Comment> fetchedComment = await commentService.fetchComments(chapterId);
      if (!mounted) return;
      setState(() {
        comments = fetchedComment;
      });
    } catch (e) {
      print("fail load comment $e");
      // Hiển thị thông báo lỗi cho người dùng nếu cần
    } finally {
      setState(() {
        isLoading = false; // Ẩn CircularProgressIndicator
      });
    }
  }

  Future<void> postComment(int chapterId,int comicId, String comment) async {
    try {
       await commentService.postComment(chapterId,comicId, comment);
        fetchComments(widget.chapterId);


    } catch (e) {
      print("Failed to post comment: $e");
      // Hiển thị thông báo lỗi cho người dùng nếu cần
    }
  }
  DateFormat dateFormat = DateFormat('HH:mm - dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:  isLoading ? Center(child: CircularProgressIndicator())
            :ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {

            String createdAtString = comments[index].createdAt as String;
            DateTime createdAtDateTime = DateTime.parse(createdAtString);
            String formattedDate = dateFormat.format(createdAtDateTime);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              '${ApiConst.baseUrl}images/${comments[index].avatar}'
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.flare_sharp,
                            color: Colors.yellow, // Màu của biểu tượng
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8), // Add spacing between avatar and comment
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    comments[index].username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(comments[index].content),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Thêm bình luận...',
                  ),
                 // enabled: isLoggedIn,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  if (isLoggedIn) {
                    if (_commentController.text.isNotEmpty) {
                      postComment(
                          widget.chapterId, widget.comicId, _commentController.text);
                      _commentController.clear();
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Bạn cần đăng nhập"),
                          content: Text("Để thêm bình luận, vui lòng đăng nhập."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Bỏ qua"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to login screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text("Đăng nhập"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  
}
