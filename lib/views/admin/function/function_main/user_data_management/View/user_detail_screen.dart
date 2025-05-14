// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:rock_classifier/Models/user_models.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModels user;
  const UserDetailScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chi tiết người dùng",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              children: [
                Hero(
                  tag: 'avatar-${widget.user.uid}',
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    backgroundImage: widget.user.avatar != null ? NetworkImage(widget.user.avatar!) : null,
                    child: widget.user.avatar == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Anh đại diện',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
