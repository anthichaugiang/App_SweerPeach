import 'package:flutter/material.dart';
import 'new_stories_widget.dart';
import 'recommended_stories_widget.dart';
import 'categories_widget.dart';
import 'bxh_hot_widget.dart';

class HomePage extends StatefulWidget {
  Function(int, String) navigateToCategory;

  HomePage({required this.navigateToCategory});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Image.asset('images/logo.jpg', width: 50, height: 50),
                          SizedBox(width: 8),
                          const Text(
                            'Sweet Peach',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28),
                    NewStoriesWidget(
                      title: 'Truyện mới',
                      onTap: () => widget.navigateToCategory(1, 'newest'),
                    ),
                    SizedBox(height: 28),
                    RecommendedStoriesWidget(
                      title: 'Truyện đề xuất',
                      onTap: () => widget.navigateToCategory(1, 'recommended'),
                    ),
                    SizedBox(height: 28),
                    CategoriesWidget(
                      title: 'Phân loại',
                      onTap: () => widget.navigateToCategory(1, 'showoption'),
                    ),
                    SizedBox(height: 28),
                    BxhHotWidget(
                      title: 'BXH Hot',
                      onTap: () => widget.navigateToCategory(1, 'top'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
