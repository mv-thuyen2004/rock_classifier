import 'package:flutter/material.dart';
import 'package:rock_classifier/core/define/define.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    _selectedIndex = index;
  }

  Widget informationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,
                  color: _selectedIndex == 1 ? Colors.orange : Colors.grey),
              label: "Người dùng"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      body: Padding(
        padding: EdgeInsets.all(WIDGET_ALL),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  "Xin chào Admin",
                  style: TextStyle(
                      color: Color(0xffE57C3B),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                elevation: 6,
                child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Symbols.arrow_forward_ios,
                              size: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              informationRow("Gmail", "tnanh.vn@gmail.com"),
                              informationRow("Tên người dùng", "Trần Ngọc Anh"),
                              informationRow("Địa chỉ", "Thái Bình"),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Icon(
                    Icons.functions_sharp,
                    color: Color(0xffE57C3B),
                    size: 30,
                  ),
                  Text(
                    "Chức năng",
                    style: TextStyle(
                        color: Color(0xffE57C3B),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_forward_ios)),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, elevation: 4),
                      onPressed: null,
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          "Quản lí tài khoản người dùng",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Symbols.arrow_forward_ios)),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: ElevatedButton(
                      onPressed: null,
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          "Dữ liệu cơ sở trong ứng dụng",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 143, 158, 1),
                        Color.fromRGBO(255, 188, 143, 1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      )
                    ]),
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Create Account',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
