import 'package:flutter/material.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';
import 'package:sweet_peach_fe/screens/home/section_title_widget.dart';

import '../../apis/comic_service.dart';
import '../../models/comic.dart';


class RecommendedStoriesWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const RecommendedStoriesWidget({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: title,
          onTap: onTap,
        ),
        FutureBuilder<List<Comic>>(
          future: ComicService.fetchRecomComic(6),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null) {
              return const Text('No data available');
            } else {
              return _buildRecommendedStories(context, snapshot.data!);
            }
          },
        ),

      ],
    );
  }

  Widget _buildRecommendedStories(BuildContext context, List<Comic> list) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          Comic comic = list[index];

          String title = comic.title;
          int views = comic.views;
          int followers = comic.follows;
          String latestChapter = comic.lastChapter ;
          String coverImageUrl = comic.imageUrl;

          // Quy đổi số lượt xem và số lượt theo dõi sang đơn vị K và M
          String viewsText = _abbreviateNumber(views);
          String followersText = _abbreviateNumber(followers);

          return GestureDetector(
            onTap: () {
              // Xử lý khi nhấn vào truyện đề xuất
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black, // Màu nền cho mỗi item
                borderRadius: BorderRadius.circular(8), // Bo góc cho mỗi item
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Màu đổ bóng
                    spreadRadius: 3, // Bán kính lan rộng của bóng
                    blurRadius: 5, // Độ mờ của bóng
                    offset: Offset(0, 3), // Độ lệch của bóng
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 6,
                    child: Image.network(
                      '${ApiConst.baseUrl}images/${coverImageUrl}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 10,
                              ),
                              Text(
                                viewsText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 10,
                              ),
                              Text(
                                followersText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                 latestChapter,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  // Hàm để quy đổi số lượt xem và số lượt theo dõi sang đơn vị K và M
  String _abbreviateNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}
