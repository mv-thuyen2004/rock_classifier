import 'package:flutter/material.dart';
import 'package:rock_classifier/Models/rock_models.dart';

class RockDetailScreen extends StatefulWidget {
  final RockModels rock;

  const RockDetailScreen({super.key, required this.rock});

  @override
  State<RockDetailScreen> createState() => _RockDetailScreenState();
}

class _RockDetailScreenState extends State<RockDetailScreen> {
  late List<bool> isExpandedList;

  @override
  void initState() {
    super.initState();
    isExpandedList = List.generate(widget.rock.cauHoi!.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildImageBox(String? imagePath) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: imagePath == null ? Colors.grey : null,
          borderRadius: BorderRadius.circular(20),
          image: imagePath != null ? DecorationImage(image: NetworkImage(imagePath), fit: BoxFit.cover) : null,
        ),
        child: imagePath == null
            ? const Icon(
                Icons.image_not_supported,
                size: 30,
                color: Colors.black45,
              )
            : null,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chi tiết thẻ đá ${widget.rock.tenDa}",
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
        children: [
          const SizedBox(height: 4),
          // ảnh lớn nhất
          if (widget.rock.hinhAnh != null && widget.rock.hinhAnh!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                widget.rock.hinhAnh!.first,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
              ),
            ),
          const SizedBox(height: 16),

          //  TÊN ĐÁ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.rock.tenDa ?? "Không tên",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // LOẠI ĐÁ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Loại đá: ${widget.rock.loaiDa ?? "Chưa rõ"}',
              style: TextStyle(fontSize: 16, color: Colors.amber[900], fontWeight: FontWeight.bold),
            ),
          ),

          // kHUNG ĐÁ
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2E3856),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        buildImageBox(widget.rock.hinhAnh?[1]),
                        const SizedBox(width: 8),
                        buildImageBox(widget.rock.hinhAnh?[2]),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        buildImageBox(widget.rock.hinhAnh?[3]),
                        const SizedBox(width: 8),
                        buildImageBox(widget.rock.hinhAnh?[4]),
                      ],
                    )
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thành phần hóa học",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      widget.rock.thanhPhanHoaHoc ?? 'Chưa có dữ liệu',
                      style: TextStyle(color: Color(0xFFFF8C42), fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Độ cứng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      widget.rock.doCung ?? 'Chưa có dữ liệu',
                      style: TextStyle(color: Color(0xFFFF8C42), fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Màu sắc',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      widget.rock.mauSac ?? 'Chưa có dữ liệu',
                      style: TextStyle(color: Color(0xFFFF8C42), fontSize: 12),
                    ),
                  ],
                )),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // TIÊU ĐỀ MÔ TẢ ĐÁ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.question_answer_outlined, size: 20),
                SizedBox(width: 8),
                Text(
                  'Một số câu hỏi phổ biến',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),

          // DANH SÁCH CÂU HỎI
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: List.generate(
                widget.rock.cauHoi!.length,
                (index) {
                  return ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    title: Text(
                      widget.rock.cauHoi?[index] ?? 'Chưa có dữ liệu',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Icon(
                      isExpandedList[index] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    ),
                    onExpansionChanged: (value) {
                      setState(() {
                        isExpandedList[index] = value;
                      });
                    },
                    backgroundColor: Colors.white,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.rock.traLoi?[index] ?? 'Chưa có dữ liệu trả lời',
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // MÔ TẢ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Text(
                  'Mô tả',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Text(
              widget.rock.mieuTa ?? 'Chưa có dữ liệu ',
              style: TextStyle(fontSize: 14),
            ),
          ),

          // ĐẶC ĐIỂM CƠ BẢN
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Text(
                  'Đặc điểm cơ bản',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ĐẶC ĐIỂM
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đặc điểm :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.rock.dacDiem ?? 'Chưa có dữ liệu đặc điểm',
                        softWrap: true,
                      ),
                    )
                  ],
                ),
                Divider(height: 24),
                //NHÓM ĐÁ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nhóm đá :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.rock.nhomDa ?? 'Chưa có dữ liệu nhóm đá',
                        softWrap: true,
                      ),
                    )
                  ],
                ),
                Divider(height: 24),

                // ĐỘ CỨNG
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Độ cứng :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.rock.doCung ?? 'Chưa có dữ liệu Độ Cứng',
                        softWrap: true,
                      ),
                    )
                  ],
                ),
                Divider(height: 24),

                // MẬT ĐỘ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mật độ :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.rock.matDo ?? 'Chưa có dữ liệu mật độ',
                        softWrap: true,
                      ),
                    )
                  ],
                ),
                Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thành phần hóa học :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.rock.thanhPhanHoaHoc ?? 'Chưa có dữ liệu thành phấn hóa học',
                        softWrap: true,
                      ),
                    )
                  ],
                ),
                Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Màu sắc',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.rock.mauSac ?? 'Chưa có dữ liệu màu sắc',
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          // KIẾN TRÚC VÀ CẤU TẠO
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Text(
                  'Kiến trúc và cấu tạo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.amber[900],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Kiến trúc',
                      style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.rock.kienTruc ?? 'Chưa có dữ liệu kiến trúc',
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.amber[900],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Cấu tạo',
                      style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.rock.cauTao ?? 'Chưa có dữ liệu kiến trúc',
                ),
              ],
            ),
          ),

          // MỘT SỐ THÔNG TIN KHÁC
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Text(
                  'Một số thông tin khác',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.amber[900],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Thành phần khoáng sản',
                      style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.rock.thanhPhanKhoangSan ?? 'Chưa có dữ liệu thành phần khoáng sản',
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.amber[900],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Công dụng của khoáng sản',
                      style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.rock.congDung ?? 'Chưa có dữ liệu công dụng',
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.amber[900],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Nơi phân bố',
                      style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.rock.noiPhanBo ?? 'Chưa có dữ liệu nơi phân bố',
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.amber[900],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Một số khoáng sản liên quan',
                      style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.rock.motSoKhoangSanLienQuan ?? 'Chưa có dữ liệu một số khoáng sản liên quan',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Xử lý chỉnh sửa
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Chỉnh sửa đá',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(width: 12), // Khoảng cách giữa 2 nút
                TextButton(
                  onPressed: () {
                    // Xử lý xóa
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Xóa đá',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
