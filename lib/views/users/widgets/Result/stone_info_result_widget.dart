import 'package:flutter/material.dart';
import 'package:nckh/services/RockImageDialog.dart';

class StoneInfoWidget extends StatelessWidget {
  final bool isFavorite;
  final Function onFavoriteToggle;
  final Map<String, dynamic> stoneData;

  StoneInfoWidget({
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.stoneData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Grid Section
            if (stoneData['anh_da'] != null && stoneData['anh_da'].length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 12), // Lùi xuống 1 chút
                child: SizedBox(
                  width: 140, // Thu nhỏ chiều rộng vùng ảnh
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: stoneData['anh_da'].length - 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return _buildImage(
                          context, stoneData['anh_da'][index + 1]);
                    },
                  ),
                ),
              ),

            SizedBox(width: 16),

            // Information Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoText(
                    'Thành phần hóa học',
                    stoneData['tp_hoahoc'] ?? 'Chưa có thông tin',
                    maxLines: 2,
                  ),
                  SizedBox(height: 18),
                  _buildInfoText(
                    'Độ cứng',
                    stoneData['do_cung'] ?? 'Chưa có thông tin',
                    maxLines: 1,
                  ),
                  SizedBox(height: 18),
                  _buildInfoText(
                    'Màu sắc',
                    stoneData['mau_sac'] ?? 'Chưa có thông tin',
                    maxLines: 1,
                  ),
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

// Widget to display image with tap event
  Widget _buildImage(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        _showImageDialog(context, imagePath); // Mở dialog khi nhấn vào ảnh
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8), // Làm tròn các góc ảnh
        child: Image.network(
          imagePath, // Đảm bảo bạn đang sử dụng Image.network
          width: 60, // Đặt chiều rộng ảnh
          height: 60, // Đặt chiều cao ảnh
          fit: BoxFit.cover, // Căn chỉnh ảnh theo BoxFit.cover
          errorBuilder: (context, error, stackTrace) {
            // Xử lý lỗi nếu ảnh không thể tải
            return Icon(Icons.broken_image, size: 60, color: Colors.white);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child; // Hiển thị ảnh khi tải xong
            } else {
              // Hiển thị CircularProgressIndicator khi ảnh đang tải
              return SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Widget to display information text
  Widget _buildInfoText(String title, String value, {int maxLines = 1}) {
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
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
