import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final String title;
  final String imagePath;

  const PostScreen({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 4,
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5A55CA), // Màu tím sapphire
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('04/05/2025', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 16),
                Icon(Icons.person, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('Admin', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Đây là nội dung mẫu cho bài viết. Bạn có thể thay đổi để phù hợp với bài viết cụ thể. Đây là nội dung mẫu cho bài viết. Bạn có thể thay đổi để phù hợp với bài viết cụ thể. Đây là nội dung mẫu cho bài viết. Bạn có thể thay đổi để phù hợp với bài viết cụ thể. Đây là nội dung mẫu cho bài viết. Bạn có thể thay đổi để phù hợp với bài viết cụ thể.',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 500), // để test việc scroll
          ],
        ),
      ),
    );
  }
}
