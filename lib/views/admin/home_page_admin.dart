import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/core/define/define.dart';
import 'package:rock_classifier/core/widgets/FunctionButton.dart';
import 'package:rock_classifier/modelViews/user_provider.dart';

import '../../modelViews/user_provider.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      Future.microtask(
        () {
          Provider.of<UserProvider>(context, listen: false).fetchUserData(uid);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trang chủ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(marginOfAllApplication),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xin chào Admin",
                style: TextStyle(
                    fontSize: 28,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            user?.avatar ?? "assets/images/avatar_meo.jpg"),
                        radius: 36,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InfoRow(
                              title: "Gmail",
                              value: user?.gmail ?? "user@example.com",
                            ),
                            SizedBox(height: 8),
                            InfoRow(
                              title: "Tên người dùng",
                              value: user?.fullName ?? "User Name",
                            ),
                            SizedBox(height: 8),
                            InfoRow(
                              title: "Địa chỉ",
                              value: user?.fullName ?? "Location",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Chức Năng",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FunctionButton(
                text: "Quản lí tài khoản người dùng ",
                onPressed: () {},
              ),
              FunctionButton(
                text: "Quản lí dữ liệu đá trong ứng dụng",
                onPressed: () {},
              ),
              FunctionButton(
                text: "Quản lí các tờ báo liên quan",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.roboto(color: Colors.grey[700], fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
