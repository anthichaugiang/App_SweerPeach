import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sweet_peach_fe/screens/home/section_title_widget.dart';

import '../../apis/genre_service.dart';
import '../../dtos/top_genre_dto.dart';


class CategoriesWidget extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const CategoriesWidget({required this.title, required this.onTap});

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  bool isHotIconVisible = false;
  List<TopGenreDto> _genres = [];
  late Timer _timer = Timer(Duration.zero, (){});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: widget.title,
          onTap: widget.onTap,
        ),
        if (_genres.isNotEmpty) _buildCategories(),
      ],
    );
  }

  Widget _buildCategories() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 5 / 2,
        ),
        itemCount: _genres.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCategoryItem(index);
        },
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    TopGenreDto genre = _genres[index];
    Color color1 = _randomColor();
    Color color2 = _randomColor();
    return GestureDetector(
      onTap: () {
        // Xử lý khi bấm vào item
        // Ví dụ: Chuyển sang trang tương ứng
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'images/backc.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color1.withOpacity(0.6),
                    color2.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            if (isHotIconVisible)
              Align(
                alignment: Alignment.topRight,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 800),
                  opacity: isHotIconVisible ? 1.0 : 0.2,
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.whatshot,
                      color: Colors.red,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            Center(
              child: Text(
                genre.genreName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    _startAnimation();
    _fetchTopGenres();
  }

  void _fetchTopGenres() async {
    try {
      List<TopGenreDto> genres = await GenreService().fetchTopGenres();
      setState(() {
        _genres = genres;
      });
    } catch (e) {
      print('Error fetching top genres: $e');
      // Handle error accordingly
    }
  }
  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel(); // Hủy `_timer` nếu nó đã được khởi tạo
    }
    super.dispose();
  }

  void _startAnimation() {
    if (_timer.isActive) {
      _timer.cancel(); // Hủy timer hiện tại nếu nó đã được khởi tạo
    }
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        isHotIconVisible = !isHotIconVisible;
      });
    });
  }


  Color _randomColor() {
    final List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }
}
