import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopularRocksSection extends StatefulWidget {
  @override
  _PopularRocksSectionState createState() => _PopularRocksSectionState();
}

class _PopularRocksSectionState extends State<PopularRocksSection> {
  List<Map<String, dynamic>> uniqueRocks = [];

  @override
  void initState() {
    super.initState();
    fetchRocksData();
  }

  Future<void> fetchRocksData() async {
    final snapshot = await FirebaseFirestore.instance.collection('rock_').get();
    final allRocks = snapshot.docs.map((doc) => doc.data()).toList();

    // Lọc ra các rock có 'nhanh_da' duy nhất
    final seenNames = <String>{};
    final filtered = <Map<String, dynamic>>[];

    for (var rock in allRocks) {
      final name = rock['nhanh_da'] ?? 'Không rõ';
      if (!seenNames.contains(name)) {
        seenNames.add(name);
        filtered.add(rock);
      }
    }

    setState(() {
      uniqueRocks = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Những loại đá phổ biến",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        uniqueRocks.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: uniqueRocks.length,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final rock = uniqueRocks[index];
                    final name = rock['nhanh_da'] ?? 'Không rõ';
                    final imagePath = rock['anh_da'];

                    final imageUrl = (imagePath is List && imagePath.length > 1)
                        ? imagePath[1]
                        : (imagePath is List && imagePath.isNotEmpty)
                            ? imagePath[0]
                            : imagePath ?? 'Không có ảnh';

                    return RockCard(
                      name: name,
                      imagePath: imageUrl,
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class RockCard extends StatelessWidget {
  final String name;
  final String imagePath;

  const RockCard({required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 85,
          height: 85,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(imagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
