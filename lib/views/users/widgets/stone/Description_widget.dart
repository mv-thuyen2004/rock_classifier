import 'package:flutter/material.dart';

class Description extends StatelessWidget {
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
              'Bornite là một khoáng vật sulfua đồng sắt quan trọng, thường hình thành trong các mỏ nhiệt dịch nhiệt độ trung bình đến cao. Nó thường gặp trong các đá magma chứa đồng hoặc trong các mỏ biến chất. Khi tiếp xúc với không khí, bề mặt bornite bị oxy hóa, tạo ra hiệu ứng màu sắc rực rỡ, khiến nó còn được gọi là "đá công".',
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
