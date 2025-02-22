import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> rockTypes = [
    {
      'name': 'Andesit',
      'image': 'assets/andesit.png',
      'category': 'Đá trung tính'
    },
    {
      'name': 'Amphibolit',
      'image': 'assets/amphibolit.png',
      'category': 'Đá mafic'
    },
    {'name': 'Bazan', 'image': 'assets/bazan.png', 'category': 'Bazo'},
    {'name': 'Diorit', 'image': 'assets/diorit.png', 'category': 'Magma'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(), // ✅ Đã thêm phương thức
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntroCard(), // ✅ Đã thêm phương thức
                    SizedBox(height: 10),
                    _buildPopularRocks(), // ✅ Đã thêm phương thức
                    SizedBox(height: 10),
                    _buildCategoryFilter(), // ✅ Đã thêm phương thức
                    SizedBox(height: 10),
                    _buildRockGrid(), // ✅ Đã thêm phương thức
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {},
        child: Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// **📌 Phương thức tạo thanh tìm kiếm**
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.account_circle, size: 30, color: Colors.black),
        ],
      ),
    );
  }

  /// **📌 Phương thức tạo hộp "Khởi đầu (0/10)"**
  Widget _buildIntroCard() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFFEE9A0), // Màu nền vàng nhạt
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/rock_icon.png', width: 40, height: 40),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khởi đầu (0/10)',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Nhận biết đá và thêm vào bộ sưu tập của bạn để nâng cấp tiến trình',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _buildActionButton(
                      Icons.camera_alt, 'Nhận diện\nnhững viên đá')),
              SizedBox(width: 10),
              Expanded(
                  child: _buildActionButton(
                      Icons.info, 'So sánh\ntừng loại với nhau')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1E293B), // Màu nền xanh đậm
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: Colors.white),
              SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  /// **📌 Phương thức tạo thanh điều hướng dưới cùng**
  Widget _buildBottomNavigation() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              icon: Icon(Icons.home, color: Colors.black), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.library_books, color: Colors.black),
              onPressed: () {}),
          SizedBox(width: 40), // Để tạo khoảng trống cho FloatingActionButton
          IconButton(
              icon: Icon(Icons.favorite, color: Colors.black),
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.question_answer, color: Colors.black),
              onPressed: () {}),
        ],
      ),
    );
  }
}
