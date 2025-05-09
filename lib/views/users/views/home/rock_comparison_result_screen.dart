import 'package:flutter/material.dart';
import 'package:nckh/views/home/home_page.dart';

class RockComparisonResultScreen extends StatelessWidget {
  final Map<String, dynamic> firstStone;
  final Map<String, dynamic> secondStone;

  const RockComparisonResultScreen({
    super.key,
    required this.firstStone,
    required this.secondStone,
  });

  @override
  Widget build(BuildContext context) {
    print("First Stone: ${firstStone['name']}");
    print("Second Stone: ${secondStone['name']}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Quay lại",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Về trang chủ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Kết quả so sánh",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Table(
                      border: TableBorder.symmetric(
                        inside:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FixedColumnWidth(150),
                        1: FixedColumnWidth(180),
                        2: FixedColumnWidth(180),
                      },
                      children: [
                        _buildHeaderRow(
                            firstStone['ten_da'], secondStone['ten_da']),
                        _buildImageRow(
                          (firstStone['anh_da'] is List &&
                                  (firstStone['anh_da'] as List).isNotEmpty)
                              ? firstStone['anh_da'][0]
                              : null,
                          (secondStone['anh_da'] is List &&
                                  (secondStone['anh_da'] as List).isNotEmpty)
                              ? secondStone['anh_da'][0]
                              : null,
                        ),
                        ..._buildDataRowFromMap(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildHeaderRow(String? name1, String? name2) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      children: [
        const _TableCellText("Tên loại đá\nvà tính chất", isHeader: true),
        _TableCellText(name1 ?? "", isHeader: true),
        _TableCellText(name2 ?? "", isHeader: true),
      ],
    );
  }

  TableRow _buildImageRow(String? image1, String? image2) {
    return TableRow(
      children: [
        const _TableCellText("Hình ảnh\nminh họa"),
        _buildImageCell(image1),
        _buildImageCell(image2),
      ],
    );
  }

  Widget _buildImageCell(String? path) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: path != null
            ? Image.network(path, height: 80, width: 100, fit: BoxFit.cover)
            : const Icon(Icons.image_not_supported,
                size: 60, color: Colors.grey),
      ),
    );
  }

  List<TableRow> _buildDataRowFromMap() {
    final List<String> attributes = [
      "loai_da",
      "nhom_da",
      "dac_diem",
      "tp_hoahoc",
      "do_cung",
      "kien_truc",
      "cau_tao",
    ];

    final List<String> attributeLabels = [
      "Loại đá",
      "Nhóm đá",
      "Đặc điểm",
      "Thành phần hóa học",
      "Độ cứng",
      "Kiến trúc",
      "Cấu tạo",
    ];

    return List.generate(attributes.length, (index) {
      final key = attributes[index];
      return _buildDataRow(
        attributeLabels[index],
        firstStone[key]?.toString() ?? "—",
        secondStone[key]?.toString() ?? "—",
      );
    });
  }

  TableRow _buildDataRow(String title, String value1, String value2) {
    return TableRow(
      children: [
        _TableCellText(title, isLeftTitle: true),
        _TableCellText(value1),
        _TableCellText(value2),
      ],
    );
  }
}

class _TableCellText extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isLeftTitle;

  const _TableCellText(this.text,
      {this.isHeader = false, this.isLeftTitle = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      alignment: Alignment.center,
      color: isHeader ? Colors.orange.shade100 : Colors.white,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isHeader ? 18 : 16,
          fontWeight:
              isHeader || isLeftTitle ? FontWeight.bold : FontWeight.normal,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }
}
