import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rock_classifier/Models/user_models.dart';

class UserCard extends StatelessWidget {
  final UserModels user;
  final VoidCallback onMorePressed;

  const UserCard({super.key, required this.user, required this.onMorePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
          child: user.avatar == null ? const Icon(Icons.person) : null,
        ),
        title: Text(
          user.fullName ?? 'Chưa có tên',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          user.email ?? 'Chưa có email',
          style: GoogleFonts.poppins(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          onPressed: onMorePressed,
        ),
      ),
    );
  }
}
