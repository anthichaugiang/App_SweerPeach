import 'package:flutter/material.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SectionTitleWidget({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Màu nền cho phần tiêu đề
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Thêm padding cho tiêu đề
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Spacer(),
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  'Nhiều hơn',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
