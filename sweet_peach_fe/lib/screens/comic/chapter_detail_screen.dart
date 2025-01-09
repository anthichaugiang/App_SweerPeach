import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sweet_peach_fe/apis/follow_service.dart';

import '../../apis/api_const.dart';
import '../../apis/auth_service.dart';
import '../../apis/chapter_service.dart';
import '../../apis/history_service.dart';
import '../../models/comic.dart';
import '../../models/image_chapter.dart';
import '../user/login_screen.dart';
import 'comment_view.dart';

class ChapterDetailScreen extends StatefulWidget {
  final int chapterId;
  final List<Map<String, dynamic>> chapters;
  final int comicId;

  ChapterDetailScreen({required this.chapterId, required this.chapters,  required this.comicId});

  @override
  _ChapterDetailScreenState createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  AuthService _authService = AuthService();
  late int? _userId;
  final followService= FollowService();
  final historyService= HistoryService();
  final chapterService = ChapterService();
  late ScrollController _scrollController;
  int currentChapterId =1;
  bool isFavorite = false;
  bool isFilterVisible = false;
  String selectedSortingOption = 'Mới nhất';
  bool isAutoScrolling = false;
  List<ImageChapter> images = [];

  @override
  void initState() {
    super.initState();
    currentChapterId = widget.chapterId;
    fetchChapterImages(currentChapterId);
    _loadUserId();
    _scrollController = ScrollController();

  }
  Future<void> _initializeFavoriteStatus() async {
    if (_userId != null) {
      bool isFollowed = await _isComicFollowed(widget.comicId);
      setState(() {
        print('aaaa: ${isFollowed}');
        isFavorite = isFollowed;
      });
    } else {
      setState(() {
        isFavorite = false;
      });
    }
  }
  Future<void> _loadUserId() async {
    int? userId = await _authService.getUserId();
    setState(() {
      _userId = userId;
    });
    _initializeFavoriteStatus();
  }
  void _startAutoScroll() {
    double currentOffset = _scrollController.offset;
    double viewportHeight = MediaQuery.of(context).size.height*0.8;
    double targetOffset = currentOffset + viewportHeight;
    isAutoScrolling = true;
    _scrollController.animateTo(
      targetOffset,
      duration: Duration(seconds: 2),
      curve: Curves.ease,
    );
  }
  void _stopAutoScroll() {
    isAutoScrolling = false;
  }
  Future<void> _autoScroll() async {
    while (isAutoScrolling) {
      await Future.delayed(Duration(seconds: 5));
      if (isAutoScrolling) {
        _startAutoScroll();
      }else{
        break;
      }
    }
  }
  Future<void> addReadingHistory(int chapterId) async {
    // Đợi kết quả của historyService.addReadingHistory
    await historyService.addReadingHistory(widget.comicId, chapterId);
  }
  Future<void> incrementViewCount(int chapterId) async {
    await chapterService.incrementViewCount(chapterId) ;
  }
  Future<bool> _isComicFollowed(int comicId) async {
    if (_userId != null) {
      List<Comic> followedComics = await followService.getFollowComic();
      return followedComics.any((comic) => comic.comicId == comicId);
    }
    return false;
  }
  Future<void>  followComic(int userId,int comicId)async {
    await followService.followComic(userId, comicId);
  }
  Future<void>  unfollowComic(int userId,int comicId)async {
    await followService.unfollowComic(userId, comicId);
  }
  Future<void> fetchChapterImages(int chapterId) async {
    try {
      List<ImageChapter> fetchedImages =
      await chapterService.getImagesChapterByChapterId(chapterId);
      setState(() {
        images = fetchedImages;
      });
      await addReadingHistory(chapterId);
      await incrementViewCount(chapterId);
    } catch (e) {
      print('Error fetching chapter images: $e');
    }
  }


  void toggleFilterVisibility() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
  }
  void sortChapters(String option) {
    setState(() {
      selectedSortingOption = option;
      if (option == 'Cũ nhất') {
        widget.chapters.sort((a, b) => a['chapterId'].compareTo(b['chapterId']));
      } else {
        widget.chapters.sort((a, b) => b['chapterId'].compareTo(a['chapterId']));
      }
    });
  }

  void onChapterSelected(int chapterId) {
    setState(() {
      currentChapterId = chapterId;
      isFilterVisible = false; // Đóng toggle khi chọn một chương
    });
    fetchChapterImages(currentChapterId);
  }
  Future<void> _handleFollowButton() async {
    if (_userId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Yêu cầu đăng nhập'),
            content: Text('Vui lòng đăng nhập để theo dõi truyện.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('Đăng nhập'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                },
                child: Text('Bỏ qua'),
              ),
            ],
          );
        },
      );
    } else {
      bool isFollowed = await _isComicFollowed(widget.comicId);
      print(isFollowed);
      if (isFollowed) {
        await unfollowComic(_userId!, widget.comicId);
      } else {
        await followComic(_userId!, widget.comicId);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Bọc toàn bộ nội dung trong GestureDetector
      onTap: () {
        setState(() {
          isFilterVisible = false; // Đóng toggle khi bấm bên ngoài toggle
        });
      },
      child: Scaffold(

        backgroundColor: Colors.transparent,
        body: NestedScrollView(

          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black.withOpacity(0.4),
                title: Text(
                  widget.chapters
                      .firstWhere((chapter) => chapter['chapterId'] == currentChapterId)['title'],
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
                centerTitle: true,
                floating: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      _handleFollowButton();
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ],
              ),
            ];
          },
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: images.length + 1, // Số lượng phần tử = số lượng ảnh + 1 (tab nhỏ)
                        itemBuilder: (context, index) {
                          if (index < images.length) {
                            // Hiển thị ảnh
                            return Image.network(
                              ApiConst.baseUrl + 'images/' + images[index].imagePath,
                              fit: BoxFit.contain,
                            );
                          } else {
                            return SingleChildScrollView( // Sử dụng SingleChildScrollView thay thế cho Container
                              child: Column(
                                children: [
                                  Container(
                                    height: 350, // Chiều cao của tab nhỏ
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CommentScreen(chapterId: widget.chapterId, comicId: widget.comicId,),
                                  ),
                                ],
                              ),
                            );

                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              isFilterVisible ? Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height:  MediaQuery.of(context).size.height * 0.5 ,
                  color: Colors.black,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                sortChapters('Cũ nhất');
                              },
                              child: Text(
                                'Cũ nhất',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  selectedSortingOption == 'Cũ nhất' ? Colors.red : Colors.grey,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                sortChapters('Mới nhất');
                              },
                              child: Text(
                                'Mới nhất',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  selectedSortingOption == 'Mới nhất' ? Colors.red : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded( // Bọc ListView.builder trong Expanded để nó mở rộng theo chiều dọc
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.chapters.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                widget.chapters[index]['title'],
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                onChapterSelected(widget.chapters[index]['chapterId']);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Container(),
            ],
          ),

        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed:currentChapterId <= 1 ? null : () {
                  setState(() {
                    currentChapterId--;
                  });
                  fetchChapterImages(currentChapterId);
                },
              ),
              IconButton(
                icon: Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  toggleFilterVisibility();
                },
              ),
              IconButton(
                icon: Icon(
                  isAutoScrolling ? Icons.stop: Icons.play_arrow  ,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (isAutoScrolling) {
                      _stopAutoScroll();
                    } else {
                      _startAutoScroll();
                      _autoScroll();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed:  currentChapterId >= widget.chapters.length ? null :() {
                  setState(() {
                    currentChapterId++;
                  });
                  fetchChapterImages(currentChapterId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

