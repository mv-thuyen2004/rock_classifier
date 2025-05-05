import 'package:flutter/material.dart';

class UpdateInformationAdmin extends StatefulWidget {
  const UpdateInformationAdmin({super.key});

  @override
  State<UpdateInformationAdmin> createState() => _UpdateInformationAdminState();
}

class _UpdateInformationAdminState extends State<UpdateInformationAdmin> {
  String fullName = "Trần Ngọc Anh";
  String address = "Thái Bình";
  String email = "tnanh.vn@gmail.com";

  Future<void> _editField(
      {required String title,
      required String currentValue,
      required Function(String) onSave}) async {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
          ),
          content: TextField(
            controller: controller,
            autofocus: false, // Để bàn phím không tự động hiện ra khi mở dialog
            decoration: InputDecoration(hintText: "Nhập $title"),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red)),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green),
              ),
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: Text(
                'Lưu',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: () {}, child: Text("Lưu"))],
        title: Text(
          "Thông tin người dùng",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        // Ảnh đại diện
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFF0F0F0),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Ảnh đại diện",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Chưa có",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.teal),
                              )
                            ],
                          ),
                        ),
                        // Họ và tên
                        InkWell(
                          onTap: () {
                            _editField(
                              title: "Họ và tên",
                              currentValue: fullName,
                              onSave: (newValue) {
                                setState(() {
                                  fullName = newValue;
                                });
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFF0F0F0),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Họ và tên",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  fullName,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.teal),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Địa chỉ
                        InkWell(
                          onTap: () {
                            _editField(
                              title: "Địa chỉ",
                              currentValue: address,
                              onSave: (newValue) {
                                setState(() {
                                  address = newValue;
                                });
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Địa chỉ",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  address,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.teal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // label Tai khoan va mat khau
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(top: 12),
                    child: const Text(
                      "Tài khoản và mật khẩu",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        // Địa chỉ email
                        InkWell(
                          onTap: () {
                            _editField(
                              title: "Email",
                              currentValue: email,
                              onSave: (newValue) {
                                setState(() {
                                  email = newValue;
                                });
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFF0F0F0),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Địa chỉ Email",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.teal),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Mật khẩu
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFF0F0F0),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mật khẩu",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Viết chức năng thay đổi mật khẩu ở đây
                                },
                                child: Text(
                                  "Thay đổi mật khẩu",
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
