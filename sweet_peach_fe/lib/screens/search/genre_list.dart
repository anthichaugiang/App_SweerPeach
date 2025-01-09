import 'package:flutter/material.dart';
import 'dart:ui';

import '../../apis/genre_service.dart';
import '../../models/genre.dart';

class GenreList extends StatefulWidget {
  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  int selectedIndex = 0;
  bool isCategorySelected = false;
  bool isSortSelected = false;
  bool isApplySelected = false;
  late List<Genre> genres = [];

  @override
  void initState() {
    super.initState();
    fetchAllGenresFromApi();
  }

  Future<void> fetchAllGenresFromApi() async {
    try {
      final genreService = GenreService();
      final List<Genre> fetchedGenres = await genreService.fetchAllGenres();
      setState(() {
        genres = fetchedGenres;
      });
    } catch (e) {
      print('Error fetching genres: $e');
    }
  }
  void navigateToSearchWithGenre(Genre genre) {
    Navigator.pop(context, {'category': 'byGenre', 'genreId': genre.id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isCategorySelected = true;
                          isSortSelected = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Thể Loại',
                          style: TextStyle(
                            color: Colors.white ,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10, // Khoảng cách giữa các ô
                  runSpacing: 10, // Khoảng cách giữa các dòng
                  children: [
                    for (var genre in genres)
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = genres.indexOf(genre);
                            isCategorySelected = true;
                          });
                          navigateToSearchWithGenre(genre);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedIndex == genres.indexOf(genre) ? Colors.red : Colors.transparent,
                          ),
                          child: Text(
                            genre.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
