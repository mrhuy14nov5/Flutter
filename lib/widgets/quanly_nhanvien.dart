import 'package:flutter/material.dart';
import '../models/nhanvien.dart';
import '../models/data_store.dart';

class QuanLyNhanVien extends StatefulWidget {
  const QuanLyNhanVien({Key? key}) : super(key: key);

  @override
  State<QuanLyNhanVien> createState() => _QuanLyNhanVienState();
}

class _QuanLyNhanVienState extends State<QuanLyNhanVien> {
  String tuKhoaTimKiem = '';
  final _formKey = GlobalKey<FormState>();

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEdit ? 'Cập Nhật Hồ Sơ' : 'Thêm Nhân Viên Mới',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(txtMaNV, 'Mã Nhân Viên *',
                    enabled: !isEdit, isRequired: true),
                _buildTextField(txtHoTen, 'Họ và tên *', isRequired: true),
                _buildTextField(txtNamSinh, 'Năm sinh', isNumber: true),
                _buildTextField(txtGioiTinh, 'Giới tính'),
                _buildTextField(txtTrinhDo, 'Trình độ chuyên môn'),
                _buildTextField(txtQueQuan, 'Quê quán'),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
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
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lưu dữ liệu thành công!')));
              }
            },
            child: const Text('Xác nhận Lưu'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool enabled = true, bool isRequired = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
            ? (val) =>
                val == null || val.isEmpty ? 'Vui lòng nhập thông tin' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var danhSachLoc = DataStore.danhSachNhanVien.where((nv) {
      return nv.hoTen.toLowerCase().contains(tuKhoaTimKiem.toLowerCase()) ||
          nv.maNV.toLowerCase().contains(tuKhoaTimKiem.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Danh Sách Nhân Viên')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm nhân viên...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey.shade800,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (giatri) => setState(() => tuKhoaTimKiem = giatri),
            ),
          ),
          Expanded(
            child: danhSachLoc.isEmpty
                ? const Center(
                    child: Text('Không có dữ liệu phù hợp.',
                        style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: danhSachLoc.length,
                    itemBuilder: (context, index) {
                      final nv = danhSachLoc[index];
                      return Dismissible(
                        key: Key(nv.maNV),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.delete_outline,
                              color: Colors.white, size: 28),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: const Text("Xác nhận"),
                              content:
                                  Text("Bạn muốn xóa hồ sơ của ${nv.hoTen}?"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text("Hủy",
                                        style: TextStyle(color: Colors.grey))),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text("Xóa",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          setState(() => DataStore.danhSachNhanVien
                              .removeWhere((item) => item.maNV == nv.maNV));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
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
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.indigo.withOpacity(0.1),
                              child: Text(
                                  nv.hoTen.isNotEmpty
                                      ? nv.hoTen[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                      fontSize: 18)),
                            ),
                            title: Text(nv.hoTen,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Text('ID: ${nv.maNV}  •  ${nv.trinhDo}'),
                            trailing: IconButton(
                                icon: const Icon(Icons.edit_note_rounded,
                                    color: Colors.blueGrey, size: 28),
                                onPressed: () => _hienDialogNhanVien(nv: nv)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () => _hienDialogNhanVien(),
        icon: const Icon(Icons.add),
        label: const Text('Thêm Mới',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
