import 'package:flutter/material.dart';
import '../models/chucvu.dart';
import '../models/data_store.dart';

class QuanLyChucVu extends StatefulWidget {
  const QuanLyChucVu({Key? key}) : super(key: key);

  @override
  State<QuanLyChucVu> createState() => _QuanLyChucVuState();
}

class _QuanLyChucVuState extends State<QuanLyChucVu> {
  void _hienDialogChucVu({ChucVu? cv}) {
    final isEdit = cv != null;
    final txtMaCV = TextEditingController(text: cv?.maChucVu ?? '');
    final txtTenCV = TextEditingController(text: cv?.tenChucVu ?? '');
    final txtMoTa = TextEditingController(text: cv?.moTa ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Cập Nhật Chức Vụ' : 'Thêm Chức Vụ Mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: txtMaCV,
              enabled: !isEdit,
              decoration: const InputDecoration(labelText: 'Mã Chức Vụ'),
            ),
            TextField(
                controller: txtTenCV,
                decoration: const InputDecoration(labelText: 'Tên chức vụ')),
            TextField(
                controller: txtMoTa,
                decoration:
                    const InputDecoration(labelText: 'Mô tả công việc')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (txtMaCV.text.isEmpty || txtTenCV.text.isEmpty) return;
              setState(() {
                if (isEdit) {
                  cv.tenChucVu = txtTenCV.text;
                  cv.moTa = txtMoTa.text;
                } else {
                  DataStore.danhSachChucVu.add(ChucVu(
                    maChucVu: txtMaCV.text,
                    tenChucVu: txtTenCV.text,
                    moTa: txtMoTa.text,
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
      appBar: AppBar(title: const Text('Danh Sách Chức Vụ')),
      body: DataStore.danhSachChucVu.isEmpty
          ? const Center(child: Text('Chưa có dữ liệu chức vụ.'))
          : ListView.builder(
              itemCount: DataStore.danhSachChucVu.length,
              itemBuilder: (context, index) {
                final cv = DataStore.danhSachChucVu[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('${cv.maChucVu} - ${cv.tenChucVu}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(cv.moTa),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _hienDialogChucVu(cv: cv)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              DataStore.danhSachChucVu.removeAt(index);
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
        onPressed: () => _hienDialogChucVu(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
