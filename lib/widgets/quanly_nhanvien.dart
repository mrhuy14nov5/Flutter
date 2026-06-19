import 'package:flutter/material.dart';
import '../models/nhanvien.dart';
import '../models/data_store.dart';

class QuanLyNhanVien extends StatefulWidget {
  const QuanLyNhanVien({Key? key}) : super(key: key);

  @override
  State<QuanLyNhanVien> createState() => _QuanLyNhanVienState();
}

class _QuanLyNhanVienState extends State<QuanLyNhanVien> {
  void _hienDialogNhanVien({NhanVien? nv}) {
    final isEdit = nv != null;
    final txtMaNV = TextEditingController(text: nv?.maNV ?? '');
    final txtHoTen = TextEditingController(text: nv?.hoTen ?? '');
    final txtNamSinh =
        TextEditingController(text: nv?.namSinh.toString() ?? '');
    final txtGioiTinh = TextEditingController(text: nv?.gioiTinh ?? 'Nam');
    final txtTrinhDo = TextEditingController(text: nv?.trinhDo ?? '');
    final txtQueQuan = TextEditingController(text: nv?.queQuan ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Cập Nhật Nhân Viên' : 'Thêm Nhân Viên Mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtMaNV,
                enabled: !isEdit,
                decoration:
                    const InputDecoration(labelText: 'Mã Nhân Viên (Mã NV)'),
              ),
              TextField(
                  controller: txtHoTen,
                  decoration: const InputDecoration(labelText: 'Họ và tên')),
              TextField(
                  controller: txtNamSinh,
                  decoration: const InputDecoration(labelText: 'Năm sinh'),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: txtGioiTinh,
                  decoration: const InputDecoration(labelText: 'Giới tính')),
              TextField(
                  controller: txtTrinhDo,
                  decoration:
                      const InputDecoration(labelText: 'Trình độ chuyên môn')),
              TextField(
                  controller: txtQueQuan,
                  decoration: const InputDecoration(labelText: 'Quê quán')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (txtMaNV.text.isEmpty || txtHoTen.text.isEmpty) return;
              setState(() {
                if (isEdit) {
                  nv.hoTen = txtHoTen.text;
                  nv.namSinh = int.tryParse(txtNamSinh.text) ?? 2000;
                  nv.gioiTinh = txtGioiTinh.text;
                  nv.trinhDo = txtTrinhDo.text;
                  nv.queQuan = txtQueQuan.text;
                } else {
                  DataStore.danhSachNhanVien.add(NhanVien(
                    maNV: txtMaNV.text,
                    hoTen: txtHoTen.text,
                    namSinh: int.tryParse(txtNamSinh.text) ?? 2000,
                    gioiTinh: txtGioiTinh.text,
                    trinhDo: txtTrinhDo.text,
                    queQuan: txtQueQuan.text,
                  ));
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh Sách Nhân Viên')),
      body: DataStore.danhSachNhanVien.isEmpty
          ? const Center(child: Text('Danh sách nhân viên trống.'))
          : ListView.builder(
              itemCount: DataStore.danhSachNhanVien.length,
              itemBuilder: (context, index) {
                final nv = DataStore.danhSachNhanVien[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('${nv.maNV} - ${nv.hoTen}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'NS: ${nv.namSinh} | GT: ${nv.gioiTinh}\nTĐ: ${nv.trinhDo} | Quê: ${nv.queQuan}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _hienDialogNhanVien(nv: nv)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              DataStore.danhSachNhanVien.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _hienDialogNhanVien(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
