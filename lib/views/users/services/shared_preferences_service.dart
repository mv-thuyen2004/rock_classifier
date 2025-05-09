import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> loginSuccess() async {
  // Lấy đối tượng người dùng từ Firebase Authentication
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final String uid = user.uid; // Lấy UID của người dùng đăng nhập

    // Lưu trạng thái đăng nhập và UID vào SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true); // Lưu trạng thái đăng nhập
    await prefs.setString('user_id', uid); // Lưu UID người dùng
  } else {
    print('Người dùng không đăng nhập.');
  }
}
