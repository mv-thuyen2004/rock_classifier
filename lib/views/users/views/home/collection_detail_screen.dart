import 'package:flutter/material.dart';

class CollectionDetailScreen extends StatelessWidget {
  const CollectionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Bộ sưu tập chi tiết',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Thứ tự"),
                    _buildTextField(hintText: "1"),
                    const SizedBox(height: 16),
                    _buildLabel("Tên của bộ sưu tập"),
                    _buildTextField(hintText: "Bộ sưu tập của tôi ...."),
                    const SizedBox(height: 16),
                    _buildLabel("Hình ảnh"),
                    Row(
                      children: [
                        _buildImageBox(imagePath: 'assets/demo_1.jpg'),
                        const SizedBox(width: 12),
                        _buildAddImageBox(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Thời gian"),
                    _buildTextField(hintText: "Nhập thời gian..."),
                    const SizedBox(height: 16),
                    _buildLabel("Địa điểm"),
                    _buildTextField(hintText: "Nhập địa điểm..."),
                    const SizedBox(height: 16),
                    _buildLabel("Ghi chú"),
                    _buildNoteField(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Nút lưu
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        color: const Color(0xFFF8F8F8),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              print('Lưu bộ sưu tập');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6792B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Text(
              "LƯU",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==== Các Widget nhỏ ====

  Widget _buildLabel(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTextField({String? hintText, bool enabled = true}) {
    return TextField(
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey, // Hint màu xám nhạt
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Không viền
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // ✅ Không đổi viền khi focus
        ),
      ),
      style: const TextStyle(
        fontSize: 18, // Text người nhập to rõ
        color: Colors.black, // Text người nhập màu đen
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNoteField() {
    return TextField(
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Thêm vào ghi chú",
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildImageBox({required String imagePath}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAddImageBox() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.add, size: 32, color: Colors.grey),
      ),
    );
  }
}
