import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/screens/utils/abbreviate.dart';
import '../../apis/comic_service.dart';
import '../../apis/history_service.dart';
import '../../dtos/comic_dto.dart';
import '../../models/Chapter.dart';
import '../../models/comic.dart';
import 'chapter_detail_screen.dart';

class ComicDetailScreen extends StatefulWidget {
  final int comicId;

  const ComicDetailScreen({Key? key, required this.comicId}) : super(key: key);

  @override
  _ComicDetailScreenState createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen> {
  late ComicDto comic;
  late List<Chapter> chapters;
  int selectedChapterIndex = -1;
  bool oldestSelected = false;
  bool newestSelected = false;
  bool isInHistory = false;
  bool isLoading = true;
  int? mostRecentChapterId;
  @override
  void initState() {
    super.initState();
    fetchComicDetail();

  }

  void sortChapters(bool ascending) {
    setState(() {
      if (ascending) {
        chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
      } else {
        chapters.sort((a, b) => b.chapterNumber.compareTo(a.chapterNumber));
      }
      oldestSelected = ascending;
      newestSelected = ! ascending;
    });
  }

  void _onChapterTap(int index) {
    List<Map<String, dynamic>> chapterList = chapters.map((chapter) {
      return {
        'chapterId': chapter.id,
        'title': chapter.title,
        // Thêm các thông tin khác nếu cần
      };
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterDetailScreen(chapterId: chapters[index].id, chapters: chapterList, comicId: comic.id,),
      ),
    );
  }


  Widget buildSortButton(bool isOldest, String label) {
    return ElevatedButton(
      onPressed: () => sortChapters(isOldest),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed) || (isOldest && oldestSelected) || (!isOldest && newestSelected)) {
            return Colors.red;
          }
          return Colors.black;
        }),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text(label),
    );
  }

  Future<void> fetchComicDetail() async {
    try {
      ComicService comicService = ComicService();
      ComicDto fetchedComic = await comicService.fetchComic(widget.comicId);
      setState(() {
        comic = fetchedComic;
        chapters = comic.chapters;
        isLoading = false;
        sortChapters(false);
        checkHistory();
      });
    } catch (e) {
      print('Error fetching comic detail: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading ? _buildLoadingIndicator() : _buildComicDetail(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black, // Đặt màu nền của BottomAppBar là màu đen
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _onNavigationButtonTap(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Đặt màu nền của nút là màu trắng
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Đặt màu chữ của nút là màu đen
              ),
              child: Text(
                isInHistory ? 'Đọc tiếp  ' : 'Đọc từ đầu',
                style: TextStyle(color: Colors.black), // Đặt màu chữ của nút là màu đen
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildComicDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(ApiConst.baseUrl + 'images/' + comic.coverImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Text(
                  comic.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: 2,
                  color: Colors.white,
                ),

                SizedBox(height: 10.0),
                Row(
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.greenAccent),
                    SizedBox(width: 5.0),
                    Text(
                      abbreviateNumber(comic.viewCount),
                      style: TextStyle(fontSize: 16, color: Colors.white, decoration: TextDecoration.none),
                    ),
                    SizedBox(width: 20.0),
                    Icon(Icons.favorite, color: Colors.pinkAccent),
                    SizedBox(width: 5.0),
                    Text(
                      abbreviateNumber(comic.followCount),
                      style: TextStyle(fontSize: 16, color: Colors.white, decoration: TextDecoration.none),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: comic.genres.map((genre) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20), // Bo tròn các góc của container
                            color: Colors.blueGrey,
                          ),
                          child: Text(
                            genre,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                Text(
                  comic.description,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 2,
                  color: Colors.white,
                ),


              ],
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.3),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chapter',
                      style: TextStyle(fontSize: 20, color: Colors.white, decoration: TextDecoration.none),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        buildSortButton(true, 'Oldest'),
                        SizedBox(width: 10),
                        buildSortButton(false, 'Newest'),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedChapterIndex = index;
                  });
                  _onChapterTap(index);
                },
                child: Container(
                  color: selectedChapterIndex == index ? Colors.red : Colors.black54,
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              chapters[index].title,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye, color: Colors.grey, size: 14),
                                SizedBox(width: 2),
                                Text(
                                  abbreviateNumber(chapters[index].viewCount),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.update, color: Colors.grey, size: 14),
                                SizedBox(width: 2),
                                Text(
                                  DateFormat.yMMMd().add_Hm().format(chapters[index].updatedAt),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                          ],

                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

              );
            },
          ),
        ],
      ),
    );
  }

  void checkHistory() async {
    try {
      HistoryService historyService = HistoryService();
      List<Comic> history = await historyService.getReadingHistory();
      bool isInHistory1 = history.any((element) => element.comicId == widget.comicId);

      setState(() {
        isInHistory = isInHistory1;
      });

      if (isInHistory) {
        // Find the title of the last chapter in the history
        Comic? historyEntry = history.firstWhere((element) => element.comicId == widget.comicId, );
        String lastChapterTitle = historyEntry.lastChapter;

        // Find the id of the chapter with the corresponding title
        Chapter? lastChapter = chapters.firstWhere((chapter) => chapter.title == lastChapterTitle,);
        mostRecentChapterId = lastChapter.id;
                  }

      setState(() {
        mostRecentChapterId = mostRecentChapterId;
        print("ok:${mostRecentChapterId}");
      });
    } catch (e) {
      print('Error checking reading history: $e');
    }
  }

  void _onNavigationButtonTap() {

    if (isInHistory && mostRecentChapterId != null) {
      // Navigate to ChapterDetailScreen with most recent chapterId
      List<Map<String, dynamic>> chapterList = chapters.map((chapter) {
        return {
          'chapterId': chapter.id,
          'title': chapter.title,
          // Add other information if needed
        };
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterDetailScreen(
            chapterId: mostRecentChapterId!,
            chapters: chapterList,
            comicId: widget.comicId,
          ),
        ),
      );
    } else {
      // Navigate to ChapterDetailScreen with the first chapterId
      if (chapters.isNotEmpty) {
        List<Map<String, dynamic>> chapterList = chapters.map((chapter) {
          return {
            'chapterId': chapter.id,
            'title': chapter.title,
            // Add other information if needed
          };
        }).toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChapterDetailScreen(
              chapterId: chapters.last.id,
              chapters: chapterList,
              comicId: widget.comicId,
            ),
          ),
        );
      }
    }
  }


}
