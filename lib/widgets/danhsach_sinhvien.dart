import 'package:flutter/material.dart';
import '../models/sinhvien.dart';

class DanhSachSinhVien extends StatelessWidget {
  final List<SinhVien> danhSachSinhVien;

  DanhSachSinhVien(this.danhSachSinhVien);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: danhSachSinhVien.map((sv) {
        return Card(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.purple,
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  sv.diemTotNghiep.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.purple,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sv.ma.toString() + ' - ' + sv.hoVaTen,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sv.ngaySinh.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
