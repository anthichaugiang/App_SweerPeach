import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweet_peach_fe/screens/search/search_screen.dart';
import 'book_case/book_case.dart';
import 'user/login_screen.dart';
import 'user/my_profile.dart';
import 'home/HomePage.dart';

class IndexController extends StatefulWidget {
  @override
  _IndexControllerState createState() => _IndexControllerState();
}

class _IndexControllerState extends State<IndexController> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;

  final List<Widget> _pages = [
    HomePage(navigateToCategory: (index, category) {}),
    Search(category: 'all'),
    Bookcase(),
    MyProfile(),
  ];

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) { // Check if the tapped index corresponds to search button
      setState(() {
        _selectedIndex = index;
        _pages[_selectedIndex] = Search(category: 'all'); // Set category to 'all' for search page
      });
    } else if (index == 3) {
      if (_isLoggedIn) {
        setState(() {
          _selectedIndex = index;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ).then((value) {
          _checkLoginStatus();
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  void _navigateToCategory(int index, String? category) {
    final selectedCategory = category ?? 'all';
    setState(() {
      _selectedIndex = index;
      _pages[_selectedIndex] = Search(category: selectedCategory);
    });
  }


  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    ( _pages[0] as HomePage).navigateToCategory = _navigateToCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Tủ sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }
}
