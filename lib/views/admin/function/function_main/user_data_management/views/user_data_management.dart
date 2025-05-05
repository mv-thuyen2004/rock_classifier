import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rock_classifier/FirebaseService/firebase_service.dart';
import 'package:rock_classifier/ModelViews/user_view_model.dart';
import 'package:rock_classifier/Models/user_models.dart';
import '../widgets/user_card.dart';

class UserDataManagement extends StatefulWidget {
  const UserDataManagement({super.key});

  @override
  State<UserDataManagement> createState() => _UserDataManagementState();
}

enum SortOption { createdAt, role, name }

class _UserDataManagementState extends State<UserDataManagement>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _fadeAnimation;
  String? _currentUserRole;
  List<UserModels> _users = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
        if (_searchText.isNotEmpty) {
          _logSearch();
        }
      });
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _animationController!, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
    );
    _loadCurrentUserRole();
    _loadUsers();
  }

  Future<void> _loadCurrentUserRole() async {
    final role = await Provider.of<FirebaseService>(context, listen: false)
        .getCurrentUserRole();
    setState(() {
      _currentUserRole = role;
    });
  }

  Future<void> _loadUsers(
      {bool nextPage = false, bool previousPage = false}) async {
    if (_isLoading || (!_hasMore && nextPage)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (previousPage && _currentPage > 1) {
        _currentPage--;
        _lastDocument = null;
        _users.clear();
        for (int i = 1; i < _currentPage; i++) {
          final result =
              await Provider.of<UserViewModel>(context, listen: false)
                  .getUsersPaginated(
            pageSize: _pageSize,
            lastDocument: _lastDocument,
          );
          _lastDocument = result['lastDocument'] as DocumentSnapshot?;
        }
      } else if (nextPage && _hasMore) {
        _currentPage++;
      } else if (!nextPage && !previousPage) {
        _currentPage = 1;
        _lastDocument = null;
        _users.clear();
      }

      final result = await Provider.of<UserViewModel>(context, listen: false)
          .getUsersPaginated(
        pageSize: _pageSize,
        lastDocument: _lastDocument,
      );

      final newUsers = (result['users'] as List<UserModels>).where((user) {
        return user.gmail?.toLowerCase().contains(_searchText.toLowerCase()) ??
            false;
      }).toList();

      setState(() {
        _users = newUsers;
        _lastDocument = result['lastDocument'] as DocumentSnapshot?;
        _hasMore = newUsers.length == _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Lỗi khi tải dữ liệu: $e", style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _logSearch() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final role = userDoc.data()?['role'] as String?;
      if (role == 'User') {
        await Provider.of<UserViewModel>(context, listen: false)
            .addSearchLog(user.uid, _searchText);
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<bool> _requestPermissionDialog(BuildContext context) async {
    final permission =
        Platform.isAndroid && int.parse(Platform.version.split('.')[0]) < 13
            ? Permission.storage
            : Permission.photos;
    final status = await permission.status;
    debugPrint('Trạng thái quyền: $status');

    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isLimited) {
      final newStatus = await permission.request();
      debugPrint('Trạng thái quyền sau khi yêu cầu: $newStatus');
      if (newStatus.isGranted) {
        return true;
      } else {
        // ignore: use_build_context_synchronously
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

  void _showAddUserSheet(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    String? avatarUrl;
    String? emailError;
    String? selectedRole = 'User';
    bool isPressed = false;
    File? tempImage;

    _animationController?.forward();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SlideTransition(
              position: _slideAnimation!,
              child: FadeTransition(
                opacity: _fadeAnimation!,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFF8FAFC)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Thêm người dùng",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.grey, size: 28),
                                onPressed: () {
                                  _animationController
                                      ?.reverse()
                                      .then((_) => Navigator.pop(context));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                              labelText: "Họ và tên",
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFF3B82F6)),
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email,
                                  color: Color(0xFF3B82F6)),
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              errorText: emailError,
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setModalState(() {
                                emailError = _isValidEmail(value)
                                    ? null
                                    : 'Email không hợp lệ';
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: "Địa chỉ",
                              prefixIcon: const Icon(Icons.location_on,
                                  color: Color(0xFF3B82F6)),
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedRole,
                            decoration: InputDecoration(
                              labelText: "Vai trò",
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFF3B82F6)),
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2),
                              ),
                            ),
                            items: (_currentUserRole == 'Super-Class'
                                    ? ['Super-Class', 'User']
                                    : ['Admin', 'Super-Class', 'User'])
                                .map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setModalState(() {
                                selectedRole = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                avatarUrl == null
                                    ? Icons.image
                                    : Icons.check_circle,
                                key: ValueKey(avatarUrl == null),
                                color: Colors.white,
                              ),
                            ),
                            label: Text(
                              avatarUrl == null
                                  ? "Chọn ảnh đại diện"
                                  : "Đã chọn ảnh",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF60A5FA),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                            ),
                            onPressed: () async {
                              final granted =
                                  await _requestPermissionDialog(context);
                              if (granted) {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  final url = await Provider.of<UserViewModel>(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          listen: false)
                                      .uploadImage(pickedFile);
                                  if (url != null) {
                                    setModalState(() {
                                      avatarUrl = url;
                                      tempImage = File(pickedFile.path);
                                    });
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Lỗi khi tải ảnh lên",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                          if (avatarUrl != null && tempImage != null) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  tempImage!,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          StatefulBuilder(
                            builder: (context, setButtonState) {
                              return GestureDetector(
                                onTapDown: (_) =>
                                    setButtonState(() => isPressed = true),
                                onTapUp: (_) async {
                                  setButtonState(() => isPressed = false);
                                  if (emailController.text.isEmpty ||
                                      !_isValidEmail(emailController.text)) {
                                    setModalState(() {
                                      emailError = 'Vui lòng nhập email hợp lệ';
                                    });
                                    return;
                                  }
                                  if (fullNameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Vui lòng nhập họ và tên",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }
                                  if (addressController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Vui lòng nhập địa chỉ",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }
                                  if (selectedRole == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Vui lòng chọn vai trò",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }
                                  try {
                                    final newUser = UserModels(
                                      uid:
                                          'TEMP_${DateTime.now().millisecondsSinceEpoch}',
                                      fullName: fullNameController.text,
                                      address: addressController.text,
                                      gmail: emailController.text,
                                      avatar: avatarUrl,
                                      role: selectedRole,
                                    );
                                    await Provider.of<UserViewModel>(context,
                                            listen: false)
                                        .addUser(newUser);
                                    emailController.clear();
                                    fullNameController.clear();
                                    addressController.clear();
                                    _animationController
                                        ?.reverse()
                                        .then((_) => Navigator.pop(context));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Thêm người dùng thành công! Mật khẩu mặc định: tnanh1407",
                                          style: GoogleFonts.poppins(),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF3B82F6),
                                      ),
                                    );
                                    _loadUsers(); // Tải lại danh sách người dùng
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Lỗi: $e",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },
                                onTapCancel: () =>
                                    setButtonState(() => isPressed = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: isPressed ? 12 : 14),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF3B82F6),
                                        Color(0xFF60A5FA)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(isPressed ? 0.1 : 0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, isPressed ? 2 : 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Lưu",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() => _animationController?.reset());
  }

  void _showEditUserSheet(BuildContext context, UserModels user) {
    if (_currentUserRole == 'Super-Class' && user.role == 'Admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bạn không có quyền chỉnh sửa người dùng Admin",
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final TextEditingController emailController =
        TextEditingController(text: user.gmail);
    final TextEditingController fullNameController =
        TextEditingController(text: user.fullName);
    final TextEditingController addressController =
        TextEditingController(text: user.address);
    String? avatarUrl = user.avatar;
    String? emailError;
    String? selectedRole = user.role;
    bool isPressed = false;
    File? tempImage;

    _animationController?.forward();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SlideTransition(
              position: _slideAnimation!,
              child: FadeTransition(
                opacity: _fadeAnimation!,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFF8FAFC)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chỉnh sửa người dùng",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.grey, size: 28),
                                onPressed: () {
                                  _animationController
                                      ?.reverse()
                                      .then((_) => Navigator.pop(context));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                              labelText: "Họ và tên",
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFF3B82F6)),
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email,
                                  color: Color(0xFF3B82F6)),
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              errorText: emailError,
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setModalState(() {
                                emailError = _isValidEmail(value)
                                    ? null
                                    : 'Email không hợp lệ';
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: "Địa chỉ",
                              prefixIcon: const Icon(Icons.location_on,
                                  color: Color(0xFF3B82F6)),
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedRole,
                            decoration: InputDecoration(
                              labelText: "Vai trò",
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFF3B82F6)),
                              labelStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2),
                              ),
                            ),
                            items: (_currentUserRole == 'Super-Class'
                                    ? ['Super-Class', 'User']
                                    : ['Admin', 'Super-Class', 'User'])
                                .map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role, style: GoogleFonts.poppins()),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setModalState(() {
                                selectedRole = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                avatarUrl == null
                                    ? Icons.image
                                    : Icons.check_circle,
                                key: ValueKey(avatarUrl == null),
                                color: Colors.white,
                              ),
                            ),
                            label: Text(
                              avatarUrl == null
                                  ? "Chọn ảnh đại diện"
                                  : "Đã chọn ảnh",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF60A5FA),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                            ),
                            onPressed: () async {
                              final granted =
                                  await _requestPermissionDialog(context);
                              if (granted) {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  final url = await Provider.of<UserViewModel>(
                                          context,
                                          listen: false)
                                      .uploadImage(pickedFile);
                                  if (url != null) {
                                    setModalState(() {
                                      avatarUrl = url;
                                      tempImage = File(pickedFile.path);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Lỗi khi tải ảnh lên",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                          if (avatarUrl != null) ...[
                            const SizedBox(height: 16),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: tempImage != null
                                    ? Image.file(
                                        tempImage!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        avatarUrl!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.error),
                                      ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          StatefulBuilder(
                            builder: (context, setButtonState) {
                              return GestureDetector(
                                onTapDown: (_) =>
                                    setButtonState(() => isPressed = true),
                                onTapUp: (_) async {
                                  setButtonState(() => isPressed = false);
                                  if (emailController.text.isEmpty ||
                                      !_isValidEmail(emailController.text)) {
                                    setModalState(() {
                                      emailError = 'Vui lòng nhập email hợp lệ';
                                    });
                                    return;
                                  }
                                  if (fullNameController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Vui lòng nhập họ và tên",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }
                                  if (addressController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Vui lòng nhập địa chỉ",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }
                                  if (selectedRole == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Vui lòng chọn vai trò",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }
                                  try {
                                    final updatedUser = UserModels(
                                      uid: user.uid,
                                      fullName: fullNameController.text,
                                      address: addressController.text,
                                      gmail: emailController.text,
                                      avatar: avatarUrl,
                                      role: selectedRole,
                                      createdAt: user.createdAt,
                                    );
                                    await Provider.of<UserViewModel>(context,
                                            listen: false)
                                        .updateUser(updatedUser);
                                    _animationController
                                        ?.reverse()
                                        .then((_) => Navigator.pop(context));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Cập nhật người dùng thành công!",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor:
                                            const Color(0xFF3B82F6),
                                      ),
                                    );
                                    _loadUsers(); // Tải lại danh sách người dùng
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Lỗi: $e",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },
                                onTapCancel: () =>
                                    setButtonState(() => isPressed = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: isPressed ? 12 : 14),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF3B82F6),
                                        Color(0xFF60A5FA)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(isPressed ? 0.1 : 0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, isPressed ? 2 : 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Cập nhật",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() => _animationController?.reset());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black87),
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Quản lí người dùng",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Vui lòng chọn một người dùng để xem lịch sử hành động",
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm người dùng',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade100],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: PopupMenuButton<SortOption>(
                    icon: const Icon(Icons.sort, color: Colors.grey),
                    onSelected: (SortOption selected) {
                      setState(() {
                        _loadUsers(); // Tải lại khi thay đổi sắp xếp
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: SortOption.createdAt,
                        child: Text("Theo thời gian tạo",
                            style: GoogleFonts.poppins()),
                      ),
                      PopupMenuItem(
                        value: SortOption.role,
                        child:
                            Text("Theo vai trò", style: GoogleFonts.poppins()),
                      ),
                      PopupMenuItem(
                        value: SortOption.name,
                        child: Text("Theo email", style: GoogleFonts.poppins()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _users.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off,
                                size: 80, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              "Không tìm thấy người dùng",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Hãy thử tìm kiếm với từ khóa khác",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              "Tổng số người dùng: ${_users.length} (Trang $_currentPage)",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                final user = _users[index];
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: UserCard(
                                    user: user,
                                    onMorePressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.edit,
                                                    color: Color(0xFF3B82F6)),
                                                title: Text("Chỉnh sửa",
                                                    style:
                                                        GoogleFonts.poppins()),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _showEditUserSheet(
                                                      context, user);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent),
                                                title: Text("Xóa",
                                                    style:
                                                        GoogleFonts.poppins()),
                                                onTap: () {
                                                  if (_currentUserRole ==
                                                          'Super-Class' &&
                                                      user.role == 'Admin') {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Bạn không có quyền xóa người dùng Admin",
                                                          style: GoogleFonts
                                                              .poppins(),
                                                        ),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                          "Xác nhận xóa",
                                                          style: GoogleFonts
                                                              .poppins()),
                                                      content: Text(
                                                          "Bạn có chắc muốn xóa ${user.gmail}?",
                                                          style: GoogleFonts
                                                              .poppins()),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text("Hủy",
                                                              style: GoogleFonts
                                                                  .poppins()),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            try {
                                                              await Provider.of<
                                                                          UserViewModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .deleteUser(
                                                                      user);
                                                              Navigator.pop(
                                                                  context);
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      "Đã xóa người dùng",
                                                                      style: GoogleFonts
                                                                          .poppins()),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                ),
                                                              );
                                                              _loadUsers(); // Tải lại danh sách người dùng
                                                            } catch (e) {
                                                              Navigator.pop(
                                                                  // ignore: use_build_context_synchronously
                                                                  context);
                                                              ScaffoldMessenger
                                                                      // ignore: use_build_context_synchronously
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      "Lỗi: $e",
                                                                      style: GoogleFonts
                                                                          .poppins()),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Text("Xóa",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      color: Colors
                                                                          .redAccent)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: _currentPage > 1
                                      ? () => _loadUsers(previousPage: true)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B82F6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Trang trước",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _hasMore
                                      ? () => _loadUsers(nextPage: true)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B82F6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Trang sau",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            onPressed: () => _showAddUserSheet(context),
            backgroundColor: const Color(0xFF3B82F6),
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.add, size: 28, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
