class RockModels {
  String uid;
  final List<String>? hinhAnh;
  final String? tenDa;
  final String? loaiDa;
  final String? thanhPhanHoaHoc;
  final String? doCung;
  final String? mauSac;
  final List<String>? cauHoi;
  final List<String>? traLoi;
  final String? mieuTa;
  final String? dacDiem;
  final String? nhomDa;
  final String? matDo;
  final String? kienTruc;
  final String? cauTao;
  final String? thanhPhanKhoangSan;
  final String? congDung;
  final String? noiPhanBo;
  final String? motSoKhoangSanLienQuan;

  RockModels({
    required this.uid,
    this.hinhAnh,
    this.tenDa,
    this.loaiDa,
    this.thanhPhanHoaHoc,
    this.doCung,
    this.mauSac,
    this.cauHoi,
    this.traLoi,
    this.mieuTa,
    this.dacDiem,
    this.nhomDa,
    this.matDo,
    this.kienTruc,
    this.cauTao,
    this.thanhPhanKhoangSan,
    this.congDung,
    this.noiPhanBo,
    this.motSoKhoangSanLienQuan,
  });

  factory RockModels.fromJson(Map<String, dynamic> json) {
    return RockModels(
      uid: json['uid'],
      hinhAnh: List<String>.from(json['hinhAnh'] ?? []),
      tenDa: json['tenDa'],
      loaiDa: json['loaiDa'],
      thanhPhanHoaHoc: json['thanhPhanHoaHoc'],
      doCung: json['doCung'],
      mauSac: json['mauSac'],
      cauHoi: List<String>.from(json['cauHoi'] ?? []),
      traLoi: List<String>.from(json['traLoi'] ?? []),
      mieuTa: json['mieuTa'],
      dacDiem: json['dacDiem'],
      nhomDa: json['nhomDa'],
      matDo: json['matDo'],
      kienTruc: json['kienTruc'],
      cauTao: json['cauTao'],
      thanhPhanKhoangSan: json['thanhPhanKhoangSan'],
      congDung: json['congDung'],
      noiPhanBo: json['noiPhanBo'],
      motSoKhoangSanLienQuan: json['motSoKhoangSanLienQuan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'hinhAnh': hinhAnh,
      'tenDa': tenDa,
      'loaiDa': loaiDa,
      'thanhPhanHoaHoc': thanhPhanHoaHoc,
      'doCung': doCung,
      'mauSac': mauSac,
      'cauHoi': cauHoi,
      'traLoi': traLoi,
      'mieuTa': mieuTa,
      'dacDiem': dacDiem,
      'nhomDa': nhomDa,
      'matDo': matDo,
      'kienTruc': kienTruc,
      'cauTao': cauTao,
      'thanhPhanKhoangSan': thanhPhanKhoangSan,
      'congDung': congDung,
      'noiPhanBo': noiPhanBo,
      'motSoKhoangSanLienQuan': motSoKhoangSanLienQuan,
    };
  }

  RockModels copyWith({
    String? uid,
    List<String>? hinhAnh,
    String? tenDa,
    String? loaiDa,
    String? thanhPhanHoaHoc,
    String? doCung,
    String? mauSac,
    List<String>? cauHoi,
    List<String>? traLoi,
    String? mieuTa,
    String? dacDiem,
    String? nhomDa,
    String? matDo,
    String? kienTruc,
    String? cauTao,
    String? thanhPhanKhoangSan,
    String? congDung,
    String? noiPhanBo,
    String? motSoKhoangSanLienQuan,
  }) {
    return RockModels(
      uid: uid ?? this.uid,
      hinhAnh: hinhAnh ?? this.hinhAnh,
      tenDa: tenDa ?? this.tenDa,
      loaiDa: loaiDa ?? this.loaiDa,
      thanhPhanHoaHoc: thanhPhanHoaHoc ?? this.thanhPhanHoaHoc,
      doCung: doCung ?? this.doCung,
      mauSac: mauSac ?? this.mauSac,
      cauHoi: cauHoi ?? this.cauHoi,
      traLoi: traLoi ?? this.traLoi,
      mieuTa: mieuTa ?? this.mieuTa,
      dacDiem: dacDiem ?? this.dacDiem,
      nhomDa: nhomDa ?? this.nhomDa,
      matDo: matDo ?? this.matDo,
      kienTruc: kienTruc ?? this.kienTruc,
      cauTao: cauTao ?? this.cauTao,
      thanhPhanKhoangSan: thanhPhanKhoangSan ?? this.thanhPhanKhoangSan,
      congDung: congDung ?? this.congDung,
      noiPhanBo: noiPhanBo ?? this.noiPhanBo,
      motSoKhoangSanLienQuan: motSoKhoangSanLienQuan ?? this.motSoKhoangSanLienQuan,
    );
  }
}
