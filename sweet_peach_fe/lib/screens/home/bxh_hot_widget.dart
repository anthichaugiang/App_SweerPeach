import 'package:flutter/material.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/apis/comic_service.dart';
import 'package:sweet_peach_fe/screens/home/section_title_widget.dart';

import '../comic/comic_detail_screen.dart';


class BxhHotWidget extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const BxhHotWidget({required this.title, required this.onTap});

  @override
  _BxhHotWidgetState createState() => _BxhHotWidgetState();
}
class _BxhHotWidgetState extends State<BxhHotWidget> {
  String _selectedRanking = 'day';
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<List<String>> _rankings = [
    ['day', 'BXH Ngày'],
    ['week', 'BXH Tuần'],
    ['month', 'BXH Tháng']
  ];

  List<List<Map<String, dynamic>>> _Rankings = [
    [],
    [],
    [],
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    _fetchRankings('day',6);
    _fetchRankings('week',6);
    _fetchRankings('month',6);

  }

  Future<void> _fetchRankings(String period, int limit) async {
    try {
      final rankings = await ComicService.fetchRankingComic(period,limit);
      setState(() {
        switch (period) {
          case 'day':
            _Rankings[0] = _convertToRanking(rankings);
            break;
          case 'week':
            _Rankings[1] = _convertToRanking(rankings);
            break;
          case 'month':
            _Rankings[2] = _convertToRanking(rankings);
            break;
        }
      });
      return Future.value();
    } catch (e) {
      print('Error fetching rankings: $e');
    }
  }

  List<Map<String, dynamic>> _convertToRanking(List<dynamic> rankings) {
    return rankings.map((comic) {
      return {
        'comicId': comic.comicId,
        'storyName': comic.title,
        'coverImage': comic.imageUrl,
        'latestChapter': comic.lastChapter,
        'timeAgo': comic.timeSinceAdded,
        'genres': comic.genres,
        'views': comic.views,
        'follows': comic.follows,
      };
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 500),
      child: Column(
        children: [
          SectionTitleWidget(
            title: widget.title,
            onTap: widget.onTap,
          ),

          ToggleButtons(
            isSelected: List.generate(_rankings.length, (index) => _rankings[index][0] == _selectedRanking),
            onPressed: (int index) {
              setState(() {
                _selectedRanking = _rankings[index][0];
                _currentPage = index;
                _pageController.jumpToPage(_currentPage);
              });
            },
            children: _rankings.map((ranking) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  ranking[1],
                  style: TextStyle(
                    color: ranking[0] == _selectedRanking ? Colors.white : Colors.white, // Màu chữ của button được chọn là trắng, ngược lại là đen
                  ),
                ),
              );
            }).toList(),
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey[300], // Màu nền của các button
            selectedColor: Colors.pinkAccent, // Màu của button được chọn
            fillColor: Colors.pink, // Màu nền của button được chọn
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                  _selectedRanking = _rankings[_currentPage][0];
                });
              },
              children: [
                _buildRankingList(_Rankings[0]),
                _buildRankingList(_Rankings[1]),
                _buildRankingList(_Rankings[2]),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildRankingList(List<Map<String, dynamic>> ranking) {
    return ListView.builder(
      itemCount: ranking.length,
      itemBuilder: (context, index) {
        return _buildItem(ranking[index]);
      },
    );
  }

  Widget _buildItem(Map<String, dynamic> story) {
    int comicId = story['comicId'] ;
    String storyName = story['storyName'] ?? ''; // Kiểm tra null trước khi sử dụng
    String coverImage = story['coverImage'] ?? '';
    String latestChapter = story['latestChapter'] ?? '';
    String timeAgo = story['timeAgo'] ?? '';
    List<String> genres = List.from(story['genres'] ?? []);
    int views = story['views'] ?? 0;
    int follows = story['follows'] ?? 0;

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComicDetailScreen( comicId: comicId,),
            ),
          );
        },
        child:Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), // Bo tròn ảnh
                  color: Colors.grey[800], // Màu nền xám đậm
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Bo tròn ảnh
                  child: Image.network(
                    '${ApiConst.baseUrl}images/${coverImage}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storyName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Chuyển màu chữ thành màu trắng
                      ),
                    ),
                    Text('$latestChapter | $timeAgo', style: TextStyle(color: Colors.grey)), // Chuyển màu chữ thành màu trắng
                    SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      children: genres.map((genre) {
                        return _buildTag(genre);
                      }).toList(),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye, color: Colors.greenAccent),
                        SizedBox(width: 5),
                        Text(_abbreviateNumber(views), style: TextStyle(color: Colors.grey)), // Áp dụng hàm _abbreviateNumber vào số views
                        Spacer(),
                        Icon(Icons.favorite, color: Colors.pinkAccent),
                        SizedBox(width: 5),
                        Text('${_abbreviateNumber(follows)} follows', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));


  }

  String _abbreviateNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}