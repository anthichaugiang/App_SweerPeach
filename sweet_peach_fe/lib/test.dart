// import 'package:flutter/material.dart';
//
// class HomePage extends StatefulWidget {
//   Function(int, String) navigateToCategory;
//
//   HomePage({required this.navigateToCategory});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector( // Bọc toàn bộ nội dung trong GestureDetector
//       onTap: () {
//         setState(() {
//           isFilterVisible = false; // Đóng toggle khi bấm bên ngoài toggle
//         });
//       },
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: NestedScrollView(
//           floatHeaderSlivers: true,
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return <Widget>[
//               SliverAppBar(
//                 backgroundColor: Colors.black.withOpacity(0.4),
//                 title: Text(
//                   widget.chapters
//                       .firstWhere((chapter) => chapter['chapterId'] == currentChapterId)['title'],
//                   style: TextStyle(fontSize: 24.0, color: Colors.white),
//                 ),
//                 centerTitle: true,
//                 floating: true,
//                 leading: IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   color: Colors.white,
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 actions: [
//                   IconButton(
//                     icon: Icon(
//                       isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: isFavorite ? Colors.red : Colors.white,
//                     ),
//                     onPressed: () {
//                       _handleFollowButton();
//                       setState(() {
//                         isFavorite = !isFavorite;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ];
//           },
//           body: Stack(
//             children: [
//               Column(
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child:
//                       ListView.builder(
//                         controller: _scrollController,
//                         itemCount: images.length,
//                         itemBuilder: (context, index) {
//                           return Image.network(
//                             ApiConst.baseUrl + 'images/' + images[index].imagePath,
//                             fit: BoxFit.contain,
//                           );
//                         },
//
//                       ),
//
//                     ),
//                   ),
//
//                 ],
//               ),
//               isFilterVisible ?   Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: AnimatedContainer(
//                   duration: Duration(milliseconds: 400),
//                   height:  MediaQuery.of(context).size.height * 0.5 ,
//                   color: Colors.black,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () {
//                                 sortChapters('Cũ nhất');
//                               },
//                               child: Text(
//                                 'Cũ nhất',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all<Color>(
//                                   selectedSortingOption == 'Cũ nhất' ? Colors.red : Colors.grey,
//                                 ),
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 sortChapters('Mới nhất');
//                               },
//                               child: Text(
//                                 'Mới nhất',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all<Color>(
//                                   selectedSortingOption == 'Mới nhất' ? Colors.red : Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: widget.chapters.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(
//                                 widget.chapters[index]['title'],
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               onTap: () {
//                                 onChapterSelected(widget.chapters[index]['chapterId']);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ):Container(),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           color: Colors.transparent,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed:currentChapterId <= 1 ? null : () {
//                   setState(() {
//                     currentChapterId--;
//                   });
//                   fetchChapterImages(currentChapterId);
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.filter_list, color: Colors.white),
//                 onPressed: () {
//                   toggleFilterVisibility();
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   isAutoScrolling ? Icons.stop: Icons.play_arrow  ,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     if (isAutoScrolling) {
//                       _stopAutoScroll();
//                     } else {
//                       _startAutoScroll();
//                       _autoScroll();
//                     }
//                   });
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.arrow_forward, color: Colors.white),
//                 onPressed:  currentChapterId >= widget.chapters.length ? null :() {
//                   setState(() {
//                     currentChapterId++;
//                   });
//                   fetchChapterImages(currentChapterId);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
