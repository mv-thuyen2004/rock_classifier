import 'package:flutter/material.dart';
import 'package:nckh/views/home/collection_detail_screen.dart';
import 'package:nckh/widgets/Result/Description_result_widget.dart';
import 'package:nckh/widgets/Result/basic_characteristics_result.dart';
import 'package:nckh/widgets/Result/stone_info_result_widget.dart';

import '../../widgets/Result/FrequentlyAskedQuestions_result.dart';
import '../../widgets/Result/OtherInformation_result_Widget.dart';
import '../../widgets/Result/StructureAndComposition_result.dart';

class ModelResultScreen extends StatefulWidget {
  final Map<String, dynamic> stoneData;

  const ModelResultScreen({required this.stoneData, Key? key})
      : super(key: key);

  @override
  _ModelResultScreenState createState() => _ModelResultScreenState();
}

class _ModelResultScreenState extends State<ModelResultScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: 'stoneImage',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: (widget.stoneData['anh_da'] is List &&
                                    widget.stoneData['anh_da'].isNotEmpty)
                                ? Image.network(
                                    widget.stoneData['anh_da'][0],
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(
                                    height: 250,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text('Không có ảnh'),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: 60,
                              height: 40,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF303A53),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.stoneData['ten_da'] ?? 'Tên đá không rõ',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Loại đá: ${widget.stoneData['nhanh_da'] ?? 'Không rõ'}, ${widget.stoneData['loai_da'] ?? 'Không rõ'}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFFE57C3B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey<bool>(isFavorite),
                                color: isFavorite ? Colors.red : Colors.grey,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 400),
                      child: StoneInfoWidget(
                        stoneData: widget.stoneData,
                        isFavorite: isFavorite,
                        onFavoriteToggle: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                    ),
                    Description(stoneData: widget.stoneData),
                    BasicCharacteristics(stoneData: widget.stoneData),
                    StructureAndComposition(stoneData: widget.stoneData),
                    FrequentlyAskedQuestions(),
                    OtherInformationWidget(stoneData: widget.stoneData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.black87,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(isFavorite),
                    color: isFavorite ? Colors.red : Colors.black,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectionDetailScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6792B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              minimumSize: const Size(200, 50),
              elevation: 0,
            ),
            child: const Text(
              "+Thêm vào bộ sưu tập",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
