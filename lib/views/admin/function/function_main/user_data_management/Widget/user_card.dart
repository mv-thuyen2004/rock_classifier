import 'package:flutter/material.dart';
import 'package:rock_classifier/Models/user_models.dart';

class UserCard extends StatelessWidget {
  final UserModels user;
  final VoidCallback? onMorePressed;
  final VoidCallback? onTap;

  const UserCard({super.key, required this.user, this.onMorePressed, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey.shade200,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Hero(
            tag: 'avatar-${user.uid}',
            child: CircleAvatar(
              radius: 24,
              backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
              child: user.avatar == null ? const Icon(Icons.person) : null,
            ),
          ),
          title: Text(
            user.fullName ?? 'Chưa có tên',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            user.email,
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: onMorePressed,
          ),
        ),
      ),
    );
  }
}
