import 'package:flutter/material.dart';

class FormNhapSinhVien extends StatelessWidget {
  final maController = TextEditingController();
  final hoVaTenController = TextEditingController();
  final diemTotNghiepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
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
    );
  }
}
