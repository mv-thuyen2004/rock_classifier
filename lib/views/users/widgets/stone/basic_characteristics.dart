import 'package:flutter/material.dart';

class BasicCharacteristics extends StatelessWidget {
  // Hàm xây dựng phần đặc điểm cơ bản
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề và giá trị
          Row(
            children: [
              // Căn chỉnh tiêu đề ra ngoài
              SizedBox(width: 0), // Khoảng cách bên trái cho tiêu đề
              Container(
                width: 120, // Cố định chiều rộng để căn chỉnh
                child: Text(
                  '$title:', // Tiêu đề thông tin
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0), // Thêm padding từ bên trái cho giá trị
                  child: Text(
                    value, // Giá trị của thông tin
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Thêm đường kẻ phân cách
          Divider(
            color: Colors.black.withOpacity(0.3),
            thickness: 1,
          ),
        ],
      ),
    );
  }

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
            // Tiêu đề chính "Đặc điểm cơ bản"
            Row(
              children: [
                Image.asset(
                  'assets/icon_basic.png', // Đường dẫn tới file ảnh icon của bạn
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 16), // Khoảng cách giữa icon và tiêu đề
                Text(
                  "Đặc điểm cơ bản", // Tiêu đề chính
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303A53), // Màu tiêu đề
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Khoảng cách giữa tiêu đề và các thông tin

            // Các thông tin đặc điểm cơ bản
            _buildInfoRow('Đặc điểm', 'Đá thành hóa lỏng (Cắt khi hoàn hảo)'),
            _buildInfoRow('Nhóm đá', 'Khoáng vật silicat'),
            _buildInfoRow('Độ cứng', '3.0 - 3.25'),
            _buildInfoRow('Mật độ', '2.7 - 3.3g/cm³'),
          ],
        ),
      ),
    );
  }
}
