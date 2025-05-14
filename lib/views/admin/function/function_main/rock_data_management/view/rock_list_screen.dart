import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rock_classifier/ModelViews/rock_view_model.dart';
import 'package:rock_classifier/Views/admin/function/function_main/rock_data_management/view/rock_detail_screen.dart';

class RockListScreen extends StatefulWidget {
  const RockListScreen({super.key});

  @override
  State<RockListScreen> createState() => _RockListScreenState();
}

class _RockListScreenState extends State<RockListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RockViewModel>(context, listen: false).fetchRocks(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String keyword) {
    final viewModel = Provider.of<RockViewModel>(context, listen: false);
    viewModel.searchRock(keyword.trim());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RockViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý tài khoản người dùng'),
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách',
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
                      hintText: 'Tìm kiếm đá...',
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
                    if (value == 'tenDa') {
                      viewModel.sortByTenDa();
                    } else if (value == 'loaiDa') {
                      viewModel.sortByLoaiDa();
                    } else if (value == 'nhomDa') {
                      viewModel.sortByNhomDa();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'tenDa',
                      child: Row(
                        children: const [
                          Icon(
                            Icons.sort_by_alpha,
                            color: Colors.blue,
                          ), // Thay Theme.of(context).primaryColor
                          SizedBox(width: 8),
                          Text(
                            'Sắp xếp theo tên đá',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black, // Thay Theme.of(context).textTheme.bodyLarge?.color
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'loaiDa',
                      child: Row(
                        children: const [
                          Icon(Icons.category, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Sắp xếp theo loại đá',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'nhomDa',
                      child: Row(
                        children: const [
                          Icon(Icons.account_tree, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Sắp xếp theo nhánh đá',
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
              'Số lượng ${viewModel.rocks.length}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error != null
                      ? Center(child: Text(viewModel.error!))
                      : ListView.builder(
                          itemCount: viewModel.rocks.length,
                          itemBuilder: (context, index) {
                            final rock = viewModel.rocks[index];
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
                                    child: (rock.hinhAnh != null && rock.hinhAnh!.isNotEmpty)
                                        ? Image.network(
                                            rock.hinhAnh!.first,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(
                                              Icons.image_not_supported,
                                              size: 30,
                                              color: Colors.grey,
                                            ),
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                              );
                                            },
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ),
                                title: Text(
                                  rock.tenDa ?? 'Không tên',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  'Loại: ${rock.loaiDa ?? "Chưa rõ"}${rock.nhomDa != null ? " \nNhánh: ${rock.nhomDa}" : ""}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RockDetailScreen(rock: rock),
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
            // showModalAddRock(context, viewModel);
          },
          backgroundColor: Colors.blue,
          tooltip: 'Thêm đá mới',
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

void showAddRockBottomSheet(BuildContext context) {
  final tenDa = TextEditingController();
  final loaiDa = TextEditingController();
  final thanhPhanHoaHoc = TextEditingController();
  final doCung = TextEditingController();
  final mauSac = TextEditingController();
  final moTa = TextEditingController();
  final dacDiem = TextEditingController();
  final nhomDa = TextEditingController();
  final matDo = TextEditingController();
  final kienTruc = TextEditingController();
  final thanhPhanKhoangSan = TextEditingController();
  final congDungKhoangSan = TextEditingController();
  final noiPhanBo = TextEditingController();
  final motSoKhoangSanLienQuan = TextEditingController();
  final cauTao = TextEditingController();
  // Câu hỏi
  final cauHoiSo1 = TextEditingController();
  final cauHoiSo2 = TextEditingController();
  final cauHoiSo3 = TextEditingController();
  final cauhoiso4 = TextEditingController();
  // Câu trả lời
  final traLoi1 = TextEditingController();
  final traLoi2 = TextEditingController();
  final traLoi3 = TextEditingController();
  final traLoi4 = TextEditingController();

  //hinh anh
  File? hinhanh1;
  File? hinhanh2;
  File? hinhanh3;
  File? hinhanh4;
  File? hinhanh5;
  //
}
