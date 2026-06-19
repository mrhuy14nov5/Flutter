class NhanVien {
  String maNV;
  String hoTen;
  int namSinh;
  String gioiTinh;
  String trinhDo;
  String queQuan;
  String? maChucVu;

  NhanVien({
    required this.maNV,
    required this.hoTen,
    required this.namSinh,
    required this.gioiTinh,
    required this.trinhDo,
    required this.queQuan,
    this.maChucVu,
  });
}
