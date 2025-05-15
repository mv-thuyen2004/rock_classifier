import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/news_view_model.dart';
import 'package:rock_classifier/Models/news_models.dart';
import 'package:rock_classifier/Views/admin/function/function_main/news_data_management/view/news_detail_screen.dart';
import 'package:rock_classifier/Views/admin/function/function_main/user_data_management/View/utils_management.dart';

class NewsDataManagement extends StatefulWidget {
  const NewsDataManagement({super.key});

  @override
  State<NewsDataManagement> createState() => _NewsDataManagementState();
}

class _NewsDataManagementState extends State<NewsDataManagement> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      // ignore: use_build_context_synchronously
      () => Provider.of<NewsViewModel>(context, listen: false).fetchNews(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String keyword) {
    final viewModel = Provider.of<NewsViewModel>(context, listen: false);
    viewModel.searchNews(keyword.trim());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewsViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        backgroundColor: Color(0xFFF7F7F7),
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Provider.of<NewsViewModel>(context, listen: false).fetchNews();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách các bài viếts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => _onSearchChanged(value),
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm ...',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.teal, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.sort,
                    color: Colors.blue,
                    size: 28,
                  ),
                  tooltip: 'Sắp xếp danh sách', // Thêm tooltip
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 8,
                  onSelected: (value) {
                    if (value == 'somNhat') {
                      viewModel.sortByCreatAtUP();
                    }
                    if (value == 'muonNhat') {
                      viewModel.sortByCreatAtDPWN();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'somNhat',
                      child: Row(
                        children: const [
                          Icon(
                            Icons.switch_access_shortcut_sharp,
                            color: Colors.blue,
                          ), // Thay Theme.of(context).primaryColor
                          SizedBox(width: 8),
                          Text(
                            'Thời gian tạo sớm nhất',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black, // Thay Theme.of(context).textTheme.bodyLarge?.color
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'muonNhat',
                      child: Row(
                        children: const [
                          Icon(Icons.category, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Thời gian tạo muộn nhất',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Số lượng bài viết : ${viewModel.news.length}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error != null
                      ? Center(child: Text(viewModel.error!))
                      : ListView.builder(
                          itemCount: viewModel.news.length,
                          itemBuilder: (context, index) {
                            final baiBao = viewModel.news[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[200],
                                    child: (baiBao.fileDinhKem != null && baiBao.fileDinhKem!.isNotEmpty)
                                        ? Image.network(
                                            baiBao.fileDinhKem ?? 'null',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.image_not_supported,
                                              size: 30,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : const Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
                                  ),
                                ),
                                title: Text(
                                  baiBao.tenBaiViet,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('dd/MM/yyyy – HH:mm').format(baiBao.createAt),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsDetailScreen(news: baiBao),
                                      ));
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () {
            showAddNewsBottomSheet(context);
          },
          backgroundColor: Colors.blue,
          tooltip: 'Thêm đá mới',
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

void showAddNewsBottomSheet(BuildContext context) {
  final tenBaiVietController = TextEditingController();
  final noiDungController = TextEditingController();
  final duongDanController = TextEditingController();

  String selectedTopic = 'Kiến Thức';
  File? tempImage;
  bool isPressed = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFF8FAFC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, -10),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 32,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Thêm Bài viết",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: tenBaiVietController,
                    decoration: InputDecoration(
                      labelText: "Tên bài viết",
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF3B82F6)),
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noiDungController,
                    decoration: InputDecoration(
                      labelText: "Nội dung bài viết",
                      prefixIcon: const Icon(Icons.email, color: Color(0xFF3B82F6)),
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: duongDanController,
                    decoration: InputDecoration(
                      labelText: "Địa chỉ đường dẫn",
                      prefixIcon: const Icon(Icons.location_on, color: Color(0xFF3B82F6)),
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedTopic,
                    decoration: InputDecoration(
                      labelText: "Vai trò",
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF3B82F6)),
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      ),
                    ),
                    items: ['Kiến Thức', 'Học Tập'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setModalState(() {
                        selectedTopic = newValue ?? 'Kiến Thức';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(
                      tempImage == null ? Icons.image : Icons.check_circle,
                      color: Colors.white,
                    ),
                    label: Text(
                      tempImage == null ? "Chọn ảnh đại diện" : "Đã chọn ảnh",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF60A5FA),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    onPressed: () async {
                      final granted = await requestPermissionDialog(context);
                      if (granted) {
                        // ignore: use_build_context_synchronously
                        final viewModel = Provider.of<NewsViewModel>(context, listen: false);
                        await viewModel.pickImage(ImageSource.gallery);
                        if (viewModel.selectedImage != null) {
                          setModalState(() {
                            tempImage = viewModel.selectedImage;
                          });
                        }
                      }
                    },
                  ),
                  if (tempImage != null) ...[
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
                  GestureDetector(
                    onTapDown: (_) => setModalState(() => isPressed = true),
                    onTapUp: (_) async {
                      setModalState(() => isPressed = false);
                      if (tenBaiVietController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Vui lòng nhập tên bài báo",
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      if (noiDungController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Vui lòng nhập nội dung"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      try {
                        final docRef = FirebaseFirestore.instance.collection('_news').doc();
                        final generatedUid = docRef.id;
                        final viewModel = Provider.of<NewsViewModel>(context, listen: false);
                        final newBaiBao = NewsModels(
                            uid: generatedUid,
                            tenBaiViet: tenBaiVietController.text,
                            noiDungBaiViet: noiDungController.text,
                            fileDinhKem: '',
                            duongDan: duongDanController.text,
                            chuDe: selectedTopic,
                            createAt: DateTime.now());
                        if (tempImage != null) {
                          await viewModel.addNewsWithImage(newBaiBao);
                        } else {
                          await viewModel.addNews(newBaiBao);
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Thêm bài báo thành công!"),
                            backgroundColor: const Color(0xFF3B82F6),
                          ),
                        );
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Lỗi: $e"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    onTapCancel: () => setModalState(() => isPressed = false),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: isPressed ? 12 : 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(isPressed ? 0.1 : 0.3),
                            blurRadius: 10,
                            offset: Offset(0, isPressed ? 2 : 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Lưu",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
