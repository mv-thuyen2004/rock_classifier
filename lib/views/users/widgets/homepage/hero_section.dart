import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nckh/models/rock_classifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nckh/views/home/ket_qua.dart';
import 'package:nckh/views/home/rock_comparison_selection_screen.dart';
import 'package:nckh/widgets/homepage/custom_dialog.dart'; // Import file màn hình kết quả

class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, 11),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset('assets/icon_logo.jpg',
                        cacheWidth: 200, // Tăng hiệu suất
                        cacheHeight: 200,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: 14),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Khởi đầu",
                      style: TextStyle(
                        color: Color(0xFFE57C3B),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1),
                    SizedBox(
                      width: 220,
                      child: Text(
                        "Nhận biết đá và thêm vào bộ sưu tập của bạn để nâng cấp tiến trình",
                        style: TextStyle(
                          color: Color(0xFFD0D3D4),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                icon: Icons.camera_alt,
                text: "Nhận biết bằng hình ảnh",
                onTap: () async {
                  final XFile? imageFile =
                      await _picker.pickImage(source: ImageSource.gallery);

                  if (imageFile != null) {
                    print("Ảnh đã chọn: ${imageFile.path}");

                    // Chuyển XFile thành img.Image
                    final bytes = await File(imageFile.path).readAsBytes();
                    final image = img.decodeImage(bytes);

                    if (image != null) {
                      // Khởi tạo classifier và load mô hình
                      final classifier = RockClassifier();
                      await classifier.loadModel();

                      // Dự đoán kết quả
                      final result = await classifier.predict(image);

                      // Lấy predictedIndex từ kết quả dự đoán
                      int predictedIndex = result['predictedIndex'];
                      double confidence = result['confidence'];
                      print(
                          "🎯 Kết quả dự đoán: $predictedIndex | Độ chính xác: ${(confidence * 100).toStringAsFixed(2)}%");

                      // Danh sách tên đá
                      final List<String> rockIds = [
                        'Basalt',
                        'Coal',
                        'Granit',
                        'Marble',
                        'Sandtone'
                      ];
                      if (confidence < 0.55 ||
                          predictedIndex < 0 ||
                          predictedIndex >= rockIds.length) {
                        showRockAlertDialog(
                          context,
                          'Không nhận diện được',
                          'Hình ảnh bạn chọn không chứa đá rõ ràng hoặc chưa có dữ liệu thông tin về đá này. Vui lòng thử lại với ảnh khác !',
                        );
                        return;
                      }

                      // Lấy tên đá từ predictedIndex
                      final String predictedRockName = rockIds[predictedIndex];

                      // Truy vấn Firestore với tên đá
                      DocumentSnapshot snapshot = await FirebaseFirestore
                          .instance
                          .collection('rock_')
                          .doc(
                              predictedRockName) // Sử dụng tên đá làm document ID
                          .get();

                      if (snapshot.exists) {
                        var data = snapshot.data() as Map<String, dynamic>;
                        print(data); // Kiểm tra dữ liệu

                        // Chuyển sang màn hình kết quả và truyền dữ liệu
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModelResultScreen(
                              stoneData: data, // Truyền dữ liệu đá
                            ),
                          ),
                        );
                      } else {
                        print("Không tìm thấy dữ liệu đá trong Firebase.");
                      }
                    }
                  }
                },
              ),
              SizedBox(width: 20), // Thêm khoảng cách giữa hai nút
              ActionButton(
                icon: Icons.compare,
                text: "So sánh các mẫu đá",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RockFirstSelectionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ActionButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95; // Nhấn xuống
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Trở lại bình thường
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      child: Material(
        color: Color(0xFFF7C873),
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.orangeAccent.withOpacity(0.3),
          highlightColor: Colors.orange.withOpacity(0.15),
          child: Container(
            width: 140,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.black, size: 28),
                SizedBox(height: 8),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
