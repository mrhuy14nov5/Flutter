import 'package:flutter/material.dart';
import 'package:helloworld/widgets/danhsach_sinhvien.dart';
import 'package:helloworld/widgets/formnhap_sinhvien.dart';
import '../models/sinhvien.dart';

class QuanLySinhVien extends StatelessWidget {
  final List<SinhVien> danhSachSinhVien = [
    SinhVien(
      ma: 12345678,
      hoVaTen: "Nguyen Thi Huong",
      ngaySinh: DateTime(2002, 8, 20),
      diemTotNghiep: 8.2,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormNhapSinhVien(),
        DanhSachSinhVien(danhSachSinhVien),
      ],
    );
  }
}
