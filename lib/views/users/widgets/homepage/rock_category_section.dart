import 'package:flutter/material.dart';
import 'package:nckh/views/home/StoneDetailScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RockCategorySection extends StatefulWidget {
  @override
  _RockCategorySectionState createState() => _RockCategorySectionState();
}

class _RockCategorySectionState extends State<RockCategorySection> {
  String selectedCategory = "Tất cả";
  List<String> categories = ["Tất cả"];
  List<Map<String, dynamic>> allRocks = [];

  @override
  void initState() {
    super.initState();
    fetchRockData();
  }

  Future<void> fetchRockData() async {
    final snapshot = await FirebaseFirestore.instance.collection('rock_').get();
    final rocks = snapshot.docs.map((doc) => doc.data()).toList();

    // Trích xuất các loại đá duy nhất
    final types = rocks
        .map((rock) => rock['nhom_da'] as String? ?? '')
        .toSet()
        .where((type) => type.isNotEmpty)
        .toList();

    setState(() {
      allRocks = rocks;
      categories = ['Tất cả', ...types];
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredRocks = selectedCategory == "Tất cả"
        ? allRocks
        : allRocks
            .where((rock) => rock['nhom_da'] == selectedCategory)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏷️ Tiêu đề
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Các nhóm đá chính",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              return GestureDetector(
                onTap: () => setState(() => selectedCategory = category),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF303A53) : Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredRocks.length,
            itemBuilder: (context, index) {
              final rock = filteredRocks[index];
              return RockCard(
                name: rock['ten_da'] ?? 'Không rõ',
                imagePath: rock['anh_da'] ?? 'assets/placeholder.jpg',
                category: rock['loai_da'] ?? 'Không rõ',
              );
            },
          ),
        ),
      ],
    );
  }
}

class RockCard extends StatefulWidget {
  final String name;
  final dynamic imagePath;
  final String category;

  RockCard({
    required this.name,
    required this.imagePath,
    required this.category,
  });

  @override
  _RockCardState createState() => _RockCardState();
}

class _RockCardState extends State<RockCard> {
  bool isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoneDetailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu imagePath là List, lấy giá trị đầu tiên hoặc chuỗi trống nếu không có giá trị
    String imageUrl = "";
    if (widget.imagePath is List) {
      imageUrl =
          (widget.imagePath as List).isNotEmpty ? widget.imagePath[0] : '';
    } else if (widget.imagePath is String) {
      imageUrl = widget.imagePath;
    }

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl, // Lấy URL ảnh từ Firebase Storage
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/placeholder.jpg',
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/placeholder.jpg', // Nếu không có ảnh
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.share, size: 14, color: Colors.black),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.category,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 100,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
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
