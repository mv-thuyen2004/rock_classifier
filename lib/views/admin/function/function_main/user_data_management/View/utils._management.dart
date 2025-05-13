import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';


// Hàm check email có hợp lệ không !
bool isValidEmail(String email) {
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

// Hàm kiểm tra cấp quyền
Future<bool> requestPermissionDialog(BuildContext context) async {
  final permission =
      Platform.isAndroid && int.parse(Platform.version.split('.')[0]) < 13
          ? Permission.storage
          : Permission.photos;
  final status = await permission.status;

  if (status.isGranted) {
    return true;
  } else if (status.isDenied || status.isLimited) {
    final newStatus = await permission.request();
    if (newStatus.isGranted) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Quyền truy cập bị từ chối. Vui lòng cấp quyền trong cài đặt.",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Cài đặt',
            textColor: Colors.white,
            onPressed: () => openAppSettings(),
          ),
        ),
      );
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Quyền truy cập bị từ chối vĩnh viễn. Vui lòng cấp quyền trong cài đặt.",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          label: 'Cài đặt',
          textColor: Colors.white,
          onPressed: () => openAppSettings(),
        ),
      ),
    );
    return false;
  }
  return false;
}
