import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:sweet_peach_fe/apis/comic_service.dart';

import '../../models/comic.dart';
import '../comic/comic_list_view.dart';
import 'genre_list.dart';

class Search extends StatefulWidget {
  late String category;
  final String? period;
  late int? genreId;
  String? searchTitle;
  String? status;

  Search({required this.category, this.period, this.genreId});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<Search> {
  bool isFocused = false;
  int selectedIndex = 0;
  List<Comic> comicList = [];

  @override
  void initState() {
    super.initState();

    _fetchComicData();
    if (widget.category == "showoption") {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _showFilterOptions(context);
      });
    }
  }

  Future<void> _fetchComicData() async {
    try {
      List<Comic> fetchedComics = await ComicService.fetchComicData(widget.category, period: widget.period, genreId: widget.genreId);
      setState(() {
        comicList = fetchedComics ;
      });
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSearchField(),
                    ),
                    IconButton(
                      icon: Icon(Icons.tune, color: Colors.white),
                      onPressed: () {
                        _showFilterOptions(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildNavigationTabs(),
                SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'My List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: ComicListView(comics: _filterComics(comicList)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      style: TextStyle(color: isFocused ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(color: Colors.white),
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
      onTap: () {
        setState(() {
          isFocused = true;
        });
      },
      onSubmitted: (value) {
        setState(() {
          isFocused = false;
        });
      },
    );
  }

  Widget _buildNavigationTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabItem(index: 0, title: 'Tất Cả', status: ''),
        _buildTabItem(index: 1, title: 'Hoàn Thành',status: 'COMPLETED'),
        _buildTabItem(index: 2, title: 'Đang Tiến Hành', status: 'ONGOING'),
      ],
    );
  }

  Widget _buildTabItem({required int index, required String title, required String status}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.status=status;
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedIndex == index ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selectedIndex == index ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GenreList()),
    );

    if (result != null) {
      final category = result['category'];
      final genreId = result['genreId'];
      if (category != null && genreId != null) {
        setState(() {
          widget.category = category;
          widget.genreId = genreId;
        });
        _fetchComicData();
      }
    }
  }

  List<Comic> _filterComics(List<Comic> comics) {
    if (widget.searchTitle != null) {
      comics = comics.where((comic) => comic.title.toUpperCase().contains(widget.searchTitle!)).toList();
    }
    if (widget.status == 'ONGOING') {
      comics = comics.where((comic) => comic.status.toUpperCase() == 'ONGOING').toList();
    } else if (widget.status == 'COMPLETED') {
      comics = comics.where((comic) => comic.status.toUpperCase() == 'COMPLETED').toList();
    }
    return comics;
  }
}
