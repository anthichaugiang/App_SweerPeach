import 'package:flutter/material.dart';
import 'package:sweet_peach_fe/apis/follow_service.dart';
import 'package:sweet_peach_fe/apis/history_service.dart';
import 'dart:ui';
import '../../models/comic.dart';
import '../comic/comic_list_view.dart';

class Bookcase extends StatefulWidget {
  String? searchTitle;
  @override
  _BookcaseState createState() => _BookcaseState();
}

class _BookcaseState extends State<Bookcase> {
  final List<String> _tabs = ["Lịch sử", "Theo dõi"];
  late List<Comic> _historyComics = [];
  late List<Comic> _followedComics = [];
  final HistoryService historyService = HistoryService();
  final FollowService followService= FollowService();
  @override
  void initState() {
    super.initState();
    _fetchHistoryComics();
    _fetchFollowedComics();
  }

  Future<void> _fetchHistoryComics() async {
    try {
      List<Comic> fetchedComics = await  historyService.getReadingHistory();
      setState(() {
        _historyComics = fetchedComics;
      });
    } catch (e) {
      print('Error fetching history comics: $e');
    }
  }

  Future<void> _fetchFollowedComics() async {
    try {
      List<Comic> fetchedComics = await followService.getFollowComic();
      setState(() {
        _followedComics = fetchedComics;
      });
    } catch (e) {
      print('Error fetching follows comics: $e');
    }
  }
  List<Comic> _filterComics(List<Comic> comics) {
    if (widget.searchTitle != null) {
      comics = comics.where((comic) => comic.title.toUpperCase().contains(widget.searchTitle!)).toList();
    }
    return comics;
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            // Main content
            Column(
              children: [
                // Title
                SizedBox(height: 100), // Placeholder for title
                // Search bar
                Container(
                  height: kToolbarHeight + 50,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm...',
                              hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                              prefixIcon: Icon(Icons.search, color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                widget.searchTitle = value.toUpperCase();
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 5),

                      ],
                    ),
                  ),
                ),
                // Tabs
                TabBar(
                  tabs: _tabs.map((String tab) {
                    return Tab(text: tab);
                  }).toList(),
                  labelColor: Colors.white,
                ),
                // Tab views
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: TabBarView(
                      children: [
                        ComicListView(comics: _filterComics(_historyComics)),
                        ComicListView(comics: _filterComics(_followedComics)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Title (positioned at top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Bookcase',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}