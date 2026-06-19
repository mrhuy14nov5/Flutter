import 'package:flutter/material.dart';
import '../models/chucvu.dart';
import '../models/data_store.dart';

class QuanLyChucVu extends StatefulWidget {
  const QuanLyChucVu({Key? key}) : super(key: key);

  @override
  State<QuanLyChucVu> createState() => _QuanLyChucVuState();
}

class _QuanLyChucVuState extends State<QuanLyChucVu> {
  final _formKey = GlobalKey<FormState>();

  void _hienDialogChucVu({ChucVu? cv}) {
    final isEdit = cv != null;
    final txtMaCV = TextEditingController(text: cv?.maChucVu ?? '');
    final txtTenCV = TextEditingController(text: cv?.tenChucVu ?? '');
    final txtMoTa = TextEditingController(text: cv?.moTa ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEdit ? 'Cập Nhật Chức Vụ' : 'Tạo Chức Vụ Mới',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(txtMaCV, 'Mã Chức Vụ *',
                  enabled: !isEdit, isRequired: true),
              _buildTextField(txtTenCV, 'Tên chức danh *', isRequired: true),
              _buildTextField(txtMoTa, 'Mô tả công việc (Tùy chọn)'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  if (isEdit) {
                    cv.tenChucVu = txtTenCV.text;
                    cv.moTa = txtMoTa.text;
                  } else {
                    DataStore.danhSachChucVu.add(ChucVu(
                        maChucVu: txtMaCV.text,
                        tenChucVu: txtTenCV.text,
                        moTa: txtMoTa.text));
                  }
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Xác nhận Lưu'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool enabled = true, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor:
              enabled ? Colors.transparent : Colors.grey.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
        validator: isRequired
            ? (val) => val == null || val.isEmpty ? 'Bắt buộc nhập' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Quản Lý Chức Vụ'), backgroundColor: Colors.teal),
      body: DataStore.danhSachChucVu.isEmpty
          ? const Center(
              child: Text('Chưa có dữ liệu.',
                  style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: DataStore.danhSachChucVu.length,
              itemBuilder: (context, index) {
                final cv = DataStore.danhSachChucVu[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text(cv.tenChucVu,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text('Mã: ${cv.maChucVu} \n${cv.moTa}')),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon:
                                const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () => _hienDialogChucVu(cv: cv)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => setState(
                              () => DataStore.danhSachChucVu.removeAt(index)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () => _hienDialogChucVu(),
        icon: const Icon(Icons.add),
        label: const Text('Thêm Chức Vụ',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
