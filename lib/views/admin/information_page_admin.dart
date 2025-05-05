import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/auth_provider.dart';
import 'package:rock_classifier/ModelViews/user_view_model.dart';
import 'package:rock_classifier/Views/admin/function/function_info/update_information_admin.dart';
import 'package:rock_classifier/Views/users/login%20_and_regis_widget/login_page.dart';

class InformationPageAdmin extends StatefulWidget {
  const InformationPageAdmin({super.key});

  @override
  State<InformationPageAdmin> createState() => _InformationPageAdminState();
}

class _InformationPageAdminState extends State<InformationPageAdmin> {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final user = userViewModel.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông Tin Người Dùng",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                CircleAvatar(
                  radius: 54,
                  backgroundImage: AssetImage("assets/images/avatar_meo.jpg"),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.fullName ?? "User Name",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                Text(
                  user?.gmail ?? "user@example.com",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Cài đặt",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text("Chỉnh sửa thông tin cá nhân"),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).primaryColor,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateInformationAdmin(),
                                ));
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(
                            Icons.language,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            "Chuyển sang ngôn ngữ Tiếng Anh",
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).primaryColor,
                          ),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(
                            Icons.wb_sunny,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            "Chuyến sang giao diện sáng",
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        )),
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    },
                    child: const Text(
                      "Đăng xuất",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
