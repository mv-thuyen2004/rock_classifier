import 'package:flutter/material.dart';

class OtherInformationWidget extends StatelessWidget {
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
              description:
                  'Chủ yếu là silicat nhôm-kali-magnesi-sắt thuộc nhóm mica đen.\n'
                  'Đồng hành với thạch anh, feldspar, muscovite trong đá granit và gneiss.',
            ),
            SizedBox(height: 12),
            _buildTitleWithDescription(
              title: '• Công dụng của khoáng sản:',
              description:
                  'Nghiên cứu đá chát (xác định điều kiện hình thành đá magma, biến chất).\n'
                  'Ứng dụng trong công nghiệp đồ gốm, phun phủ.',
            ),
            SizedBox(height: 12),
            _buildTitleWithDescription(
              title: '• Nơi phân bố:',
              description:
                  'Phổ biến trên toàn cầu, đặc biệt trong các khu vực có đá magma và biến chất: Việt Nam: Lạng Sơn, Quảng Ninh, Tây Nguyên.',
            ),
            SizedBox(height: 12),
            _buildTitleWithDescription(
              title: '• Một số khoáng sản liên quan:',
              description: 'Chalcopyrit, chalcocite, malachite, azurite.',
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
