import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quên",
                  style: GoogleFonts.montserrat(
                    fontSize: 48, //Tăng kích thước chữ
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2, //Điều chỉnh khoảng cách dòng
                    letterSpacing: 1.5, //Làm chữ trông cân đối hơn
                    shadows: [
                      Shadow(
                        color: Colors.black
                            .withOpacity(0.2), //Đổ bóng nhẹ để nhìn sang trọng
                        offset: Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                Text(
                  "Mật khẩu",
                  style: GoogleFonts.montserrat(
                    fontSize: 48, //Kích thước lớn hơn
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Ô nhập Email
            TextField(
              decoration: InputDecoration(
                hintText: "Nhập địa chỉ Email của bạn",
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF626262), //Màu xám 626262
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Color(0xFF626262)), //Đổi màu viền thành 626262
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            // Ghi chú nhỏ về cách nhận mật khẩu mới
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "* ",
                  style: GoogleFonts.montserrat(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Chúng tôi sẽ gửi cho bạn một tin nhắn để đặt hoặc đặt lại mật khẩu mới của bạn",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Color(0xFF676767),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Nút Gửi
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý gửi yêu cầu đặt lại mật khẩu
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  "Gửi",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
