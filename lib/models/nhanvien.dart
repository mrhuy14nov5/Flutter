class NhanVien {
  String maNV;
  String hoTen;
  int namSinh;
  String gioiTinh;
  String trinhDo;
  String queQuan;
  String? maChucVu; // Có thể null nếu nhân viên đó chưa được gán chức vụ

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
