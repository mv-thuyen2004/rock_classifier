import 'package:flutter/material.dart';

class FrequentlyAskedQuestions extends StatefulWidget {
  @override
  _FrequentlyAskedQuestionsState createState() =>
      _FrequentlyAskedQuestionsState();
}

class _FrequentlyAskedQuestionsState extends State<FrequentlyAskedQuestions> {
  // List lưu trữ trạng thái mở rộng của mỗi câu hỏi
  List<bool> _isExpandedList = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16), // Padding ngoài cùng cho container
      child: Container(
        padding: EdgeInsets.all(16), // Padding bên trong container
        decoration: BoxDecoration(
          color: Colors.white, // Màu nền của container
          borderRadius:
              BorderRadius.circular(12), // Bo tròn các góc của container
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Tạo bóng mờ cho container
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icon_qes.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 10), // Khoảng cách giữa icon và tiêu đề
                Text(
                  "Một số câu hỏi phổ biến", // Tiêu đề câu hỏi
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303A53), // Màu tiêu đề
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Khoảng cách giữa tiêu đề và câu hỏi

            // Các câu hỏi phổ biến
            _buildQuestionAnswer(
                'Đá Biotite có màu sắc và hình dạng ra sao?', 0),
            _buildQuestionAnswer(
                'Borntie có tên gọi thông thường khác không?', 1),
            _buildQuestionAnswer('Người ta khai thác Borntie để làm gì?', 2),
            _buildQuestionAnswer('Đá Biotite có thể xuất hiện ở đâu?', 3),
          ],
        ),
      ),
    );
  }

  // Mỗi câu hỏi và câu trả lời với ExpansionTile
  Widget _buildQuestionAnswer(String question, int index) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303A53), // Màu chữ câu hỏi
        ),
      ),
      // Thay đổi biểu tượng chỉ khi câu hỏi đó mở rộng
      trailing: AnimatedRotation(
        duration: Duration(milliseconds: 200),
        turns: _isExpandedList[index]
            ? 0.5
            : 0.0, // Quay biểu tượng chỉ khi mở rộng
        child: Icon(
          Icons.expand_more, // Biểu tượng cho "mở rộng"
          color: Color(0xFF303A53),
        ),
      ),
      // Lắng nghe sự thay đổi trạng thái mở rộng của ExpansionTile
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpandedList[index] =
              expanded; // Cập nhật trạng thái mở rộng cho câu hỏi cụ thể
        });
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100], // Màu nền cho câu trả lời khi mở rộng
              borderRadius:
                  BorderRadius.circular(8), // Bo tròn các góc của câu trả lời
            ),
            child: Text(
              'Câu trả lời sẽ được hiển thị ở đây. Bạn có thể cung cấp thêm chi tiết về loại đá này.',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
