import 'package:flutter/material.dart';

class BasicCharacteristics extends StatelessWidget {
  final Map<String, dynamic> stoneData;

  const BasicCharacteristics({
    Key? key,
    required this.stoneData,
  }) : super(key: key);

  // Hàm tạo từng dòng thông tin
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 0),
              Container(
                width: 120,
                child: Text(
                  '$title:',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            color: Colors.black.withOpacity(0.3),
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icon_basic.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 16),
                const Text(
                  "Đặc điểm cơ bản",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303A53),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                'Đặc điểm', stoneData['dac_diem'] ?? 'Chưa có thông tin'),
            _buildInfoRow(
                'Nhóm đá', stoneData['nhom_da'] ?? 'Chưa có thông tin'),
            _buildInfoRow(
                'Độ cứng', stoneData['do_cung'] ?? 'Chưa có thông tin'),
            _buildInfoRow('Mật độ', stoneData['mat_do'] ?? 'Chưa có thông tin'),
          ],
        ),
      ),
    );
  }
}
