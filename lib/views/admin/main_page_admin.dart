import 'package:flutter/material.dart';
import 'package:rock_classifier/Views/admin/home_page_admin.dart';
import 'package:rock_classifier/Views/admin/information_page_admin.dart';

class MainPageAdmin extends StatefulWidget {
  const MainPageAdmin({super.key});

  @override
  State<MainPageAdmin> createState() => _MainPageAdminState();
}

class _MainPageAdminState extends State<MainPageAdmin> {
  int _selectedIndex = 0;

  // danh sách widget con
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các danh sách widget con
    _widgetOptions = [
      const HomePageAdmin(),
      const InformationPageAdmin(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Người dùng"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
