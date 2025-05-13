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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalAddRock(context, viewModel);
        },
        backgroundColor: Colors.blue,
        tooltip: 'Thêm đá mới',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

void showModalAddRock(BuildContext context, dynamic viewModel) {
  final formKey = GlobalKey<FormState>();
  final uid = Random().nextInt(1000000).toString();
  String? tenDa;
  String? loaiDa;
  String? thanhPhanHoaHoc;
  String? doCung;
  String? mauSac;
  String? cauHoiInput;
  String? cauTraLoiInput;
  String? mieuTa;
  String? dacDiem;
  String? nhomDa;
  String? matDo;
  String? kienTruc;
  String? cauTao;
  String? thanhPhanKhoangSan;
  String? congDung;
  String? noiPhanBo;
  String? motSoKhoangSanLienQuan;
  List<XFile> selectedImages = [];
  bool isLoading = false;

  final List<String> loaiDaOptions = [
    'Đá igneous',
    'Đá trầm tích',
    'Đá biến chất',
    'Khác',
  ];

  final picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề và nút đóng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thêm đá mới',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        if (tenDa != null || loaiDa != null || selectedImages.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xác nhận'),
                              content: const Text(
                                'Bạn có muốn hủy? Dữ liệu đã nhập sẽ bị mất.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Không'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Có'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Phần 1: Thông tin cơ bản
                Text(
                  'Thông tin cơ bản',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tên đá *',
                    hintText: 'Ví dụ: Đá granite',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.label,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => tenDa = value,
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên đá' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Loại đá *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.category,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: loaiDaOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => loaiDa = value,
                  validator: (value) => value == null ? 'Vui lòng chọn loại đá' : null,
                ),

                // Phần 2: Đặc điểm vật lý
                const SizedBox(height: 16),
                Text(
                  'Đặc điểm vật lý',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Màu sắc',
                    hintText: 'Ví dụ: Trắng, xám, hồng',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.color_lens,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => mauSac = value,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Độ cứng',
                    hintText: 'Ví dụ: 6-7 (theo thang Mohs)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.build,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => doCung = value,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Thành phần hóa học',
                    hintText: 'Ví dụ: SiO2, Al2O3',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.science,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => thanhPhanHoaHoc = value,
                ),

                // Phần 3: Hình ảnh
                const SizedBox(height: 16),
                Text(
                  'Hình ảnh',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      setState(() {
                        selectedImages.add(image);
                      });
                    }
                  },
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Chọn ảnh từ thư viện'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (selectedImages.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: selectedImages.map((image) {
                      return Chip(
                        label: Text(image.name),
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 18,
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedImages.remove(image);
                          });
                        },
                        backgroundColor: Colors.blue[50],
                      );
                    }).toList(),
                  ),

                // Phần 4: Ứng dụng & Phân bố
                const SizedBox(height: 16),
                Text(
                  'Ứng dụng & Phân bố',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Công dụng',
                    hintText: 'Ví dụ: Xây dựng, trang trí',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.work,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => congDung = value,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nơi phân bố',
                    hintText: 'Ví dụ: Việt Nam, Brazil',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) => noiPhanBo = value,
                ),

                // Phần 5: Thông tin bổ sung (ẩn trong ExpansionTile)
                const SizedBox(height: 16),
                ExpansionTile(
                  title: Text(
                    'Thông tin bổ sung',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                  ),
                  children: [
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Câu hỏi (cách nhau bởi dấu phẩy)',
                        hintText: 'Ví dụ: Độ cứng là gì?, Màu sắc chính?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.question_answer,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => cauHoiInput = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Câu trả lời (cách nhau bởi dấu phẩy)',
                        hintText: 'Ví dụ: 6-7, Trắng',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.question_answer,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => cauTraLoiInput = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Miêu tả',
                        hintText: 'Ví dụ: Đá có kết cấu hạt thô',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.description,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      maxLines: 3,
                      onChanged: (value) => mieuTa = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Đặc điểm',
                        hintText: 'Ví dụ: Kết cấu phân lớp',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => dacDiem = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nhóm đá',
                        hintText: 'Ví dụ: Nhóm plutonic',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.group,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => nhomDa = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mật độ',
                        hintText: 'Ví dụ: 2.7 g/cm³',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.height,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey,
                      ),
                      onChanged: (value) => matDo = value,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Kiến trúc',
                        hintText: 'Ví dụ: Kết cấu porphyry',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.account_tree,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => kienTruc = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Cấu tạo',
                        hintText: 'Ví dụ: Hạt trung bình',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.layers,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => cauTao = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Thành phần khoáng sản',
                        hintText: 'Ví dụ: Thạch anh, fenspat',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.science,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => thanhPhanKhoangSan = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Một số khoáng sản liên quan',
                        hintText: 'Ví dụ: Thạch anh, mica',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(
                          Icons.link,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => motSoKhoangSanLienQuan = value,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

                // Nút hành động
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Hủy',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[600]!,
                            Colors.blue[400]!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text('Thêm'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
