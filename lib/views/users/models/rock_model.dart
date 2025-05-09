class RockModel {
  final String id;
  final String tenDa;
  final String moTa;
  final String nhanhDa;
  final String nhomDa;
  final String loaiDa;
  final String dacDiem;
  final String dangNam;
  final String kienTruc;
  final String thKhoangVat;
  final String tpHoaHoc;
  final String matDo;
  final String doCung;
  final String cauTao;
  final String khoangSanLq;
  final String mauSac;
  final String noiPhanBo;
  final List<String> anhDa;

  RockModel({
    required this.id,
    required this.tenDa,
    required this.moTa,
    required this.nhanhDa,
    required this.nhomDa,
    required this.loaiDa,
    required this.dacDiem,
    required this.dangNam,
    required this.kienTruc,
    required this.thKhoangVat,
    required this.tpHoaHoc,
    required this.matDo,
    required this.doCung,
    required this.cauTao,
    required this.khoangSanLq,
    required this.mauSac,
    required this.noiPhanBo,
    required this.anhDa,
  });

  factory RockModel.fromJson(Map<String, dynamic> json) {
    return RockModel(
      id: json['id'] ?? '',
      tenDa: json['ten_da'] ?? '',
      moTa: json['mo_ta'] ?? '',
      nhanhDa: json['nhanh_da'] ?? '',
      nhomDa: json['nhom_da'] ?? '',
      loaiDa: json['loai_da'] ?? '',
      dacDiem: json['dac_diem'] ?? '',
      dangNam: json['dang_nam'] ?? '',
      kienTruc: json['kien_truc'] ?? '',
      thKhoangVat: json['th_khoangvat'] ?? '',
      tpHoaHoc: json['tp_hoahoc'] ?? '',
      matDo: json['mat_do'] ?? '',
      doCung: json['do_cung'] ?? '',
      cauTao: json['cau_tao'] ?? '',
      khoangSanLq: json['khoangsan_lq'] ?? '',
      mauSac: json['mau_sac'] ?? '',
      noiPhanBo: json['noi_phanbo'] ?? '',
      anhDa: List<String>.from(json['anh_da'] ?? []),
    );
  }
}
