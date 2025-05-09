import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final Map<String, dynamic> stoneData; // Định nghĩa tham số stoneData

  // Constructor với tham số required stoneData
  Description({required this.stoneData}); // Đảm bảo tham số được truyền vào

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16), // Padding ngoài cùng cho container
      child: Container(
        padding: EdgeInsets.all(16), // Padding bên trong container
        decoration: BoxDecoration(
          color: Colors.white, // Màu nền của container
          borderRadius:
              BorderRadius.circular(14), // Bo tròn các góc của container
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Tạo bóng mờ cho container
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icon_des1.png', // Thay thế với đường dẫn tệp ảnh của bạn
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 8),
                Text(
                  'Mô tả',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              stoneData['mo_ta'] ??
                  'Tên đá không rõ', // Truyền stoneData thay vì widget.stoneData
              textAlign: TextAlign.justify, // Căn chỉnh chữ cho đều 2 bên
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
