import 'package:flutter/material.dart';

class OtherInformationWidget extends StatelessWidget {
  // Correctly define the constructor with `required` parameter
  final Map<String, dynamic> stoneData;

  OtherInformationWidget({required this.stoneData}); // Constructor definition

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
            // Tiêu đề
            Row(
              children: [
                Image.asset(
                  'assets/icon_ttk.png', // Đường dẫn tới ảnh icon_ttk.png
                  width: 30, // Điều chỉnh kích thước của ảnh nếu cần
                  height: 30,
                ),
                SizedBox(width: 8),
                Text(
                  'Một số thông tin khác',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303A53),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Tiêu đề và phần mô tả
            _buildTitleWithDescription(
              title: '• Thành phần khoáng sản:',
              description: stoneData['th_khoangvat'] ?? 'Không có thông tin',
            ),
            SizedBox(height: 12),
            _buildTitleWithDescription(
              title: '• Dạng nằm:',
              description: stoneData['dang_nam'] ?? 'Không có thông tin',
            ),
            SizedBox(height: 12),
            _buildTitleWithDescription(
              title: '• Nơi phân bố:',
              description: stoneData['noi_phanbo'] ?? 'Không có thông tin',
            ),
            SizedBox(height: 12),
            _buildTitleWithDescription(
              title: '• Một số khoáng sản liên quan:',
              description: stoneData['khoangsan_lq'] ?? 'Không có thông tin',
            ),
          ],
        ),
      ),
    );
  }

  // Widget để tạo phần tiêu đề và văn bản mô tả
  Widget _buildTitleWithDescription(
      {required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(left: 2), // Lùi vào một chút từ trái
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.orange, // Màu cam cho tiêu đề
            ),
          ),
          SizedBox(height: 8), // Khoảng cách giữa tiêu đề và mô tả
          // Văn bản mô tả
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0), // Lùi vào một chút so với tiêu đề
            child: Text(
              description,
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF303A53), // Màu mặc định cho phần văn bản mô tả
              ),
            ),
          ),
        ],
      ),
    );
  }
}
