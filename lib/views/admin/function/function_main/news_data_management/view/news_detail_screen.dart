import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/news_view_model.dart';
import 'package:rock_classifier/Models/news_models.dart';
import 'package:rock_classifier/Views/admin/function/function_main/user_data_management/View/utils_management.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsModels news;
  const NewsDetailScreen({super.key, required this.news});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
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
          "Thông tin bài báo chi tiết",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Text(
              widget.news.tenBaiViet,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Ngày tạo
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  DateFormat('dd/MM/yyyy – HH:mm').format(widget.news.createAt),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Chủ đề
            Row(
              children: [
                const Icon(Icons.category, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  widget.news.chuDe ?? 'Chưa có dữ liệu',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nội dung
            const Text(
              'Nội dung:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              widget.news.noiDungBaiViet ?? 'Chưa có dữ liệu',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Hình ảnh đính kèm
            const Text(
              'Hình ảnh đính kèm:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 240,
                color: Colors.grey[200],
                child: (widget.news.fileDinhKem != null && widget.news.fileDinhKem!.isNotEmpty)
                    ? Image.network(
                        widget.news.fileDinhKem!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Đường link đi kèm
            const Text(
              'Đường link đi kèm:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Handle tap link nếu cần
              },
              child: Text(
                widget.news.duongDan ?? 'Không có đường dẫn',
                style: const TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showEditNewsSheet(context, widget.news);
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Xác nhận xóa"),
                        content: Text("Bạn có chắc muốn xóa ${widget.news.tenBaiViet}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await Provider.of<NewsViewModel>(context, listen: false).deleteNews(widget.news.uid);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Đã xóa người dùng"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Lỗi: $e"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            child: Text("Xóa", style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    'Xóa bài',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

void showEditNewsSheet(BuildContext context, NewsModels news) {
  final TextEditingController tenBaiVietController = TextEditingController(text: news.tenBaiViet);
  final TextEditingController noiDungController = TextEditingController(text: news.noiDungBaiViet ?? '');
  final TextEditingController duongDanController = TextEditingController(text: news.duongDan ?? '');
  String? avatarUrl = news.fileDinhKem;
  String? selectedTopic = news.chuDe;
  bool isPressed = false;
  File? tempImage;

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
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24, left: 24, right: 24, top: 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chỉnh sửa bài viết",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 28), onPressed: () => Navigator.pop(context)),
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
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
                      labelText: "Đường dẫn",
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
                      labelText: "Chủ đề",
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF3B82F6)),
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2)),
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
                  if (tempImage != null || avatarUrl != null) ...[
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
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                              ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  GestureDetector(
                    //onTapDown hạ tay xuống
                    onTapDown: (_) => setModalState(() => isPressed = true),
                    // onTapUp nhấc tay lên
                    onTapUp: (_) async {
                      setModalState(() => isPressed = false);
                      if (tenBaiVietController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Vui lòng nhập Tên bài viết"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      try {
                        final viewModel = Provider.of<NewsViewModel>(context, listen: false);
                        final baiBao = NewsModels(
                            uid: news.uid,
                            tenBaiViet: tenBaiVietController.text,
                            noiDungBaiViet: noiDungController.text,
                            duongDan: duongDanController.text,
                            fileDinhKem: avatarUrl,
                            createAt: news.createAt);

                        if (tempImage != null) {
                          await viewModel.updatenNewsWithImage(baiBao);
                        } else {
                          await viewModel.updateNews(baiBao);
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Cập nhật người dùng thành công!"),
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
                          "Cập nhật",
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
