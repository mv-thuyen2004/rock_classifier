import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nckh/views/home/rock_comparison_result_screen.dart';

class RockSecondSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> firstStone; // Đá đầu tiên được chọn

  const RockSecondSelectionScreen({super.key, required this.firstStone});

  @override
  State<RockSecondSelectionScreen> createState() =>
      _RockSecondSelectionScreenState();
}

class _RockSecondSelectionScreenState extends State<RockSecondSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic>? secondStone; // Lưu mẫu đá thứ hai được chọn
  List<Map<String, dynamic>> stones = [];

  @override
  void initState() {
    super.initState();
    _fetchStones();
  }

  Future<void> _fetchStones() async {
    final snapshot = await FirebaseFirestore.instance.collection('rock_').get();
    final List<Map<String, dynamic>> loadedStones = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final imageUrl = (data['anh_da'] is List)
          ? (data['anh_da'] as List).isNotEmpty
              ? data['anh_da'][0] // Lấy ảnh đầu tiên nếu có
              : ''
          : data['anh_da'] ?? ''; // Đảm bảo có ảnh, nếu không để rỗng

      // Không hiển thị đá đầu tiên đã chọn
      if (data['ten_da'] != widget.firstStone['ten_da']) {
        loadedStones.add({
          'name': data['ten_da'] ?? 'Tên đá không có',
          'type': data['nhanh_da'] ?? 'Không có loại đá',
          'image': imageUrl,
        });
      }
    }

    setState(() {
      stones = loadedStones;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lọc các đá theo từ khóa tìm kiếm
    List<Map<String, dynamic>> filteredStones = stones.where((stone) {
      final keyword = _searchController.text.toLowerCase();
      return stone["name"]!.toLowerCase().contains(keyword) ||
          stone["type"]!.toLowerCase().contains(keyword);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: _buildSearchBar()),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.7),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              "Mẫu đá thứ nhất đã chọn",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStoneCard(widget.firstStone, highlight: true),
            const SizedBox(height: 24),
            const Text(
              "Chọn mẫu đá thứ hai",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredStones.length,
                itemBuilder: (context, index) {
                  final stone = filteredStones[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        secondStone = stone;
                      });
                    },
                    child: _buildStoneCard(
                      stone,
                      highlight: secondStone != null &&
                          stone["name"] == secondStone!["name"],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (secondStone != null) // Nếu đã chọn đá thứ hai, hiện nút So sánh
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RockComparisonResultScreen(
                          firstStone: widget.firstStone,
                          secondStone: secondStone!,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE6792B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "So sánh",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 🔍 Thanh tìm kiếm
  Widget _buildSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Colors.black54),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Tìm kiếm bằng đá và khoáng sản...",
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
              onChanged: (value) {
                setState(() {}); // Cập nhật giao diện khi nhập
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black54),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoneCard(Map<String, dynamic> stone, {bool highlight = false}) {
    final imageUrl =
        (stone["image"] is List && (stone["image"] as List).isNotEmpty)
            ? (stone["image"] as List).first
            : stone["image"];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  )
                : const Icon(Icons.broken_image, size: 70),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stone["name"] ?? "Tên đá không có",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Loại đá: ${stone["type"] ?? "Không có loại đá"}",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
