import 'package:flutter/material.dart';
import 'nhanvien.dart';
import 'chucvu.dart';

class DataStore {
  static List<NhanVien> danhSachNhanVien = [
    NhanVien(
        maNV: 'NV01',
        hoTen: 'Vương Huy Huy',
        namSinh: 1995,
        gioiTinh: 'Nam',
        trinhDo: 'Đại học',
        queQuan: 'Hà Nội',
        maChucVu: 'CV01'),
    NhanVien(
      maNV: 'NV02',
      hoTen: 'Đỗ Thị ABCD',
      namSinh: 1998,
      gioiTinh: 'Nữ',
      trinhDo: 'Cao đẳng',
      queQuan: 'Hải Phòng',
    ),
  ];

  static List<ChucVu> danhSachChucVu = [
    ChucVu(
        maChucVu: 'CV01',
        tenChucVu: 'Giám Đốc',
        moTa: 'Điều hành toàn bộ doanh nghiệp'),
    ChucVu(
        maChucVu: 'CV02',
        tenChucVu: 'Trưởng Phòng',
        moTa: 'Quản lý nhân sự phòng ban'),
    ChucVu(
        maChucVu: 'CV03',
        tenChucVu: 'Nhân Viên',
        moTa: 'Thực thi các nghiệp vụ'),
  ];

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
}
