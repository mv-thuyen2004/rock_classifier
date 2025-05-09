import 'package:flutter/material.dart';
import 'package:nckh/services/RockImageDialog.dart';

class StoneInfoWidget extends StatelessWidget {
  final bool isFavorite;
  final Function onFavoriteToggle;

  StoneInfoWidget({
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16), // Đặt padding cho tất cả các cạnh
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 8,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF303A53),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Đảm bảo các widget con căn chỉnh đều
          children: [
            // Column for image display
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageRow(
                    context, 'assets/demo_1.jpg', 'assets/demo_2.jpg'),
                SizedBox(height: 12), // Tạo khoảng cách giữa các hàng ảnh
                _buildImageRow(
                    context, 'assets/demo_3.jpg', 'assets/demo_4.jpg'),
              ],
            ),
            SizedBox(width: 16), // Điều chỉnh khoảng cách giữa ảnh và thông tin

            // Information Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoText('Công thức hóa học', 'CuFeS4'),
                  SizedBox(height: 18), // Tạo khoảng cách giữa các thông tin
                  _buildInfoText('Độ cứng', '3.0 - 3.25'),
                  SizedBox(height: 18),
                  _buildInfoText('Màu sắc', 'Đồng, cầu vồng'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => RockImageDialog(imagePath: imagePath),
    );
  }

  // Widget to display row of two images
  Widget _buildImageRow(BuildContext context, String image1, String image2) {
    return Row(
      children: [
        _buildImage(context, image1),
        SizedBox(width: 8),
        _buildImage(context, image2),
      ],
    );
  }

  // Widget to display image and handle tap event
  Widget _buildImage(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        _showImageDialog(context, imagePath);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget to display information text
  Widget _buildInfoText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 15, color: Color(0xFFE57C3B)),
        ),
      ],
    );
  }
}
