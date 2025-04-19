import 'package:flutter/material.dart';

class FunctionUpdateInformationAdmin extends StatelessWidget {
  const FunctionUpdateInformationAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildCard({required List<Widget> children}) {
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ]),
        child: Column(
          children: [children],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Lưu",
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [],
        ),
      ),
    );
  }
}
