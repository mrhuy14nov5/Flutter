import 'package:flutter/material.dart';
import 'models/sinhvien.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quan ly sinh vien",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<SinhVien> danhSachSinhVien = [
    SinhVien(
      ma: 2012332,
      hoVaTen: "Nguyen Van Cuong",
      ngaySinh: DateTime(2004, 8, 20),
      diemTotNghiep: 8.2,
    ),
    SinhVien(
      ma: 2022332,
      hoVaTen: "Nguyen Tuan Anh",
      ngaySinh: DateTime(2003, 12, 7),
      diemTotNghiep: 7.9,
    ),
  ];

  final maController = TextEditingController();
  final hoVaTenController = TextEditingController();
  final diemTotNghiepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quan ly sinh vien"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Ma sinh vien',
                  ),
                  controller: maController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Ho va ten',
                  ),
                  controller: hoVaTenController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Diem tot nghiep',
                  ),
                  controller: diemTotNghiepController,
                ),
                TextButton(
                  child: Text('Them sinh vien'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Column(
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
          ),
        ],
      ),
    );
  }
}
