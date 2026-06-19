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
        title: Text(isEdit ? 'Cập Nhật NV' : 'Thêm NV Mới'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: txtMaNV,
                  enabled: !isEdit,
                  decoration: const InputDecoration(labelText: 'Mã NV *'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Vui lòng nhập Mã NV' : null,
                ),
                TextFormField(
                  controller: txtHoTen,
                  decoration: const InputDecoration(labelText: 'Họ và tên *'),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Vui lòng nhập Họ tên'
                      : null,
                ),
                TextFormField(
                    controller: txtNamSinh,
                    decoration: const InputDecoration(labelText: 'Năm sinh'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: txtGioiTinh,
                    decoration: const InputDecoration(labelText: 'Giới tính')),
                TextFormField(
                    controller: txtTrinhDo,
                    decoration: const InputDecoration(labelText: 'Trình độ')),
                TextFormField(
                    controller: txtQueQuan,
                    decoration: const InputDecoration(labelText: 'Quê quán')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Lưu thành công!'),
                    backgroundColor: Colors.green));
              }
            },
            child: const Text('Lưu Dữ Liệu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lọc theo từ khóa
    var danhSachLoc = DataStore.danhSachNhanVien.where((nv) {
      return nv.hoTen.toLowerCase().contains(tuKhoaTimKiem.toLowerCase()) ||
          nv.maNV.toLowerCase().contains(tuKhoaTimKiem.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Nhân Viên')),
      body: Column(
        children: [
          // THANH TÌM KIẾM
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm theo tên hoặc mã...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
                // Dùng màu xám chuẩn thay vì màu của Material 3 để Flutlab không báo lỗi
                fillColor: Colors.grey.shade200,
              ),
              onChanged: (giatri) {
                setState(() {
                  tuKhoaTimKiem = giatri;
                });
              },
            ),
          ),

          // DANH SÁCH NHÂN VIÊN
          Expanded(
            child: danhSachLoc.isEmpty
                ? const Center(child: Text('Không tìm thấy nhân viên nào.'))
                : ListView.builder(
                    itemCount: danhSachLoc.length,
                    itemBuilder: (context, index) {
                      final nv = danhSachLoc[index];
                      // Vuốt để Xóa
                      return Dismissible(
                        key: Key(nv.maNV),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete_sweep,
                              color: Colors.white, size: 30),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Xác nhận xóa"),
                                content: Text(
                                    "Bạn có chắc muốn xóa [${nv.hoTen}] không?"),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Hủy")),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Xóa",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          setState(() {
                            DataStore.danhSachNhanVien
                                .removeWhere((item) => item.maNV == nv.maNV);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã xóa ${nv.hoTen}')));
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                                child: Text(
                                    nv.hoTen.isNotEmpty ? nv.hoTen[0] : '?')),
                            title: Text('${nv.maNV} - ${nv.hoTen}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text('NS: ${nv.namSinh} | ${nv.trinhDo}'),
                            trailing: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
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
        onPressed: () => _hienDialogNhanVien(),
        icon: const Icon(Icons.person_add),
        label: const Text('Thêm NV'),
      ),
    );
  }
}
