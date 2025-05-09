import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = ["Biotit", "Biotit"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          // Dấu X bên ngoài AppBar để thoát trang, có vòng tròn bao quanh
          Padding(
            padding:
                const EdgeInsets.only(right: 16), // Tạo khoảng cách đều hơn
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Đóng trang khi nhấn X ngoài
              },
              child: Container(
                padding: EdgeInsets.all(6), // Giảm padding để vòng tròn nhỏ hơn
                decoration: BoxDecoration(
                  color: Colors.white, // Màu nền của vòng tròn là trắng
                  shape: BoxShape.circle, // Bao quanh dấu "X" với hình tròn
                  border: Border.all(
                    color: Colors.black.withOpacity(0.7), // Viền đen, nhẹ nhàng
                    width: 1.5, // Độ dày viền mỏng hơn
                  ),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.black, // Màu dấu "X" là đen
                  size: 20, // Dấu "X" nhỏ hơn, hợp với vòng tròn
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Một số gợi ý dành cho bạn",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildSuggestions(),
          ],
        ),
      ),
    );
  }

  /// 🔍 **Thanh tìm kiếm có dấu X bên trong**
  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          SizedBox(width: 12),
          Icon(Icons.search, color: Colors.black54),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm kiếm bằng đá và khoáng sản...",
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
              onChanged: (value) {
                setState(() {}); // Cập nhật lại giao diện khi nhập
              },
            ),
          ),
          // Dấu "X" bên trong để xóa văn bản khi có nội dung
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12), // Căn chỉnh dấu "X"
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black54),
                onPressed: () {
                  setState(() {
                    _searchController
                        .clear(); // Xóa văn bản trong thanh tìm kiếm
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  /// 🪨 **Danh sách gợi ý**
  Widget _buildSuggestions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _suggestions.map((rock) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 12),
              child: RockCard(
                name: rock,
                imagePath:
                    "assets/demo_1.jpg", // Đổi đường dẫn hình ảnh nếu cần
                category: "Đá Magma, Đá biến chất",
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class RockCard extends StatefulWidget {
  final String name;
  final String imagePath;
  final String category;

  RockCard(
      {required this.name, required this.imagePath, required this.category});

  @override
  _RockCardState createState() => _RockCardState();
}

class _RockCardState extends State<RockCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Container(
        width: 140, // Kích thước nhỏ như trong ảnh mẫu
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.imagePath,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              children: [
                Icon(Icons.share, size: 14, color: Colors.black54),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.category,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  setState(() => isFavorite = !isFavorite);
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 3)
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black54,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
