import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nckh/views/home/home_page.dart';
import 'rock_second_selection_screen.dart';

class RockFirstSelectionScreen extends StatefulWidget {
  const RockFirstSelectionScreen({super.key});

  @override
  State<RockFirstSelectionScreen> createState() =>
      _RockFirstSelectionScreenState();
}

class _RockFirstSelectionScreenState extends State<RockFirstSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? firstStone; // Lưu mẫu đá đầu tiên
  List<Map<String, dynamic>> stones = [];

  @override
  void initState() {
    super.initState();
    fetchStones();
  }

  Future<void> fetchStones() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('rock_').limit(50).get();

    final fetched = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      stones = fetched;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredStones = stones.where((stone) {
      final name = (stone["ten_da"] ?? "").toString().toLowerCase();
      return name.contains(_searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.black.withOpacity(0.7), width: 1.5),
                ),
                child: const Icon(Icons.close, color: Colors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              "Chọn mẫu đá thứ nhất",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredStones.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredStones.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Chỉnh sửa trong build() của bạn
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RockSecondSelectionScreen(
                                  firstStone: filteredStones[
                                      index], // Truyền trực tiếp dữ liệu
                                ),
                              ),
                            );
                          },
                          child: _buildStoneCard(filteredStones[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

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
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: "Tìm kiếm bằng đá và khoáng sản...",
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
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

  Widget _buildStoneCard(Map<String, dynamic> stone) {
    final name = stone["ten_da"] ?? "Không rõ";
    final type = stone["nhanh_da"] ?? "Không rõ";

    final image = (stone["anh_da"] is List && stone["anh_da"].length > 0)
        ? stone["anh_da"][0]
        : (stone["anh_da"] ?? 'assets/placeholder.jpg');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: image.toString().startsWith('http')
                ? Image.network(image, width: 70, height: 70, fit: BoxFit.cover)
                : Image.asset(image, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Loại đá: $type",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
