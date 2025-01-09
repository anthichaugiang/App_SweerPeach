import 'package:flutter/material.dart';
import 'package:sweet_peach_fe/apis/api_const.dart';

import '../../models/comic.dart';
import '../utils/abbreviate.dart';
import 'comic_detail_screen.dart';

class ComicListView extends StatefulWidget {
  final List<Comic> comics;

  const ComicListView({Key? key, required this.comics}) : super(key: key);

  @override
  _ComicListViewState createState() => _ComicListViewState();
}

class _ComicListViewState extends State<ComicListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.comics.length,
      itemBuilder: (BuildContext context, int index) {
        final comic = widget.comics[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: ListTile(
              leading: SizedBox(
                width: 80,
                child: ClipRRect( // ClipRRect to make the image circular
                  borderRadius: BorderRadius.circular(8), // Half of the width
                  child: Image.network(
                    '${ApiConst.baseUrl}images/${comic.imageUrl}',
                    fit: BoxFit.cover,
                    height: double.infinity, // Set height to match the column
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comic.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        comic.lastChapter,
                        style: TextStyle(color: Colors.grey,fontSize: 14),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '${comic.timeSinceAdded}',
                        style: TextStyle(color: Colors.grey,fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.visibility, color: Colors.greenAccent, size: 14,),
                      SizedBox(width: 5),
                      Text(
                        '${abbreviateNumber(comic.views)}',
                        style: TextStyle(color: Colors.grey,fontSize: 14),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.favorite, color: Colors.pink,  size: 14,),
                      SizedBox(width: 5),
                      Text(
                        '${abbreviateNumber(comic.follows)}',
                        style: TextStyle(color: Colors.grey,  fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                // Navigate to the comic detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComicDetailScreen(comicId: comic.comicId),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }



}