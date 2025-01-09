import 'package:flutter/material.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';
import '../../apis/comic_service.dart';
import '../../models/comic.dart';
import '../comic/comic_detail_screen.dart';
import 'section_title_widget.dart';

class NewStoriesWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NewStoriesWidget({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: title,
          onTap: onTap,
        ),
        SizedBox(height: 16),
        FutureBuilder<List<Comic>>(
          future: ComicService.fetchNewStories(6),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null) {
              return const Text('No data available');
            } else {
              return _buildNewStories(context, snapshot.data!);
            }
          },
        ),
      ],
    );
  }

  Widget _buildNewStories(BuildContext context, List<Comic> data) {
    final itemWidth = MediaQuery.of(context).size.width * 0.33;
    String url=  '${ApiConst.baseUrl}images/';
    return Container(
      height: 160,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: data.map((comic) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComicDetailScreen( comicId: comic.comicId,),
                  ),
                );
              },
              child: Container(
                width: itemWidth,
                margin: const EdgeInsets.only(left: 14, right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                          image: DecorationImage(
                            image: NetworkImage(url+comic.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
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
                              comic.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${comic.lastChapter}  ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                Text(
                                  '${comic.timeSinceAdded}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
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
          }).toList(),
        ),
      ),
    );
  }
}
