import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rock_classifier/Views/users/login%20_and_regis_widget/register_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Color(0xFFA0A0A1),
                    ),
                    children: [
                      TextSpan(
                        text: '${_currentIndex + 1}',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(text: '/3'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Chuyển đến màn hình chính
                  },
                  child: Text(
                    'Bỏ qua',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Làm đậm chữ
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Phần PageView có hiệu ứng chuyển động
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: 3,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: buildPage(
                    image: 'assets/intro${index + 1}.png',
                    title: index == 0
                        ? 'Tra cứu thông tin'
                        : index == 1
                            ? 'Nhận dạng hình ảnh'
                            : 'Bổ sung kiến thức',
                    description: index == 0
                        ? 'Khám phá và tra cứu thông tin về đá quý, bao gồm thành phần, hình dạng và nguồn gốc của chúng.'
                        : index == 1
                            ? 'Sử dụng công nghệ nhận dạng hình ảnh để nhận dạng và phân loại chính xác các loại đá khác nhau.'
                            : 'Cung cấp kiến thức chuyên sâu về đá quý và ứng dụng của chúng trong đời sống hàng ngày.',
                  ),
                );
              },
            ),
          ),
          //Thanh điều hướng với animation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút Trước
                _currentIndex > 0
                    ? TextButton(
                        onPressed: () {
                          _controller.previousPage(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        },
                        child: Text(
                          'Trước',
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : SizedBox(width: 60),

                //Dot Indicator có animation chuyển động
                Row(
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      width: _currentIndex == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            _currentIndex == index ? Colors.black : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                // Nút Tiếp hoặc Bắt Đầu
                _currentIndex < 2
                    ? TextButton(
                        onPressed: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        },
                        child: Text(
                          'Tiếp',
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ) // Nút "Bắt Đầu"
                    : TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(_createRoute());
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'Bắt Đầu',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 600), //Speed of transition
      pageBuilder: (context, animation, secondaryAnimation) => RegisterPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          //Smooth fade-in effect
          opacity: animation,
          child: child,
        );
      },
    );
  }

  Widget buildPage(
      {required String image,
      required String title,
      required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, width: 330, height: 220),
        SizedBox(height: 20),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 24, //Tiêu đề lớn hơn
            fontWeight: FontWeight.bold,
            color: Color(0xFF5A3D26), //Màu sắc theo yêu cầu
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 16, //Mô tả nhỏ hơn
              color: Color(0xFF5A3D26), //Màu xám nhạt
            ),
          ),
        ),
      ],
    );
  }
}
