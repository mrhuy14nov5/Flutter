import 'package:flutter/material.dart';
import '../models/nhanvien.dart';
import '../models/chucvu.dart';
import '../models/data_store.dart';

class GanChucVuWidget extends StatefulWidget {
  const GanChucVuWidget({Key? key}) : super(key: key);

  @override
  State<GanChucVuWidget> createState() => _GanChucVuWidgetState();
}

class _GanChucVuWidgetState extends State<GanChucVuWidget> {
  NhanVien? nhanVienDuocChon;
  ChucVu? chucVuDuocChon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Phân Bổ Chức Vụ'),
          backgroundColor: Colors.deepOrange),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<NhanVien>(
                  decoration: InputDecoration(
                    labelText: '1. Chọn Nhân Viên',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  value: nhanVienDuocChon,
                  items: DataStore.danhSachNhanVien
                      .map((nv) => DropdownMenuItem(
                          value: nv, child: Text('${nv.maNV} - ${nv.hoTen}')))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      nhanVienDuocChon = val;
                      if (val?.maChucVu != null) {
                        var timCV = DataStore.danhSachChucVu
                            .where((cv) => cv.maChucVu == val!.maChucVu);
                        chucVuDuocChon = timCV.isNotEmpty ? timCV.first : null;
                      } else {
                        chucVuDuocChon = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ChucVu>(
                  decoration: InputDecoration(
                    labelText: '2. Chọn Chức Vụ Mới',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  value: chucVuDuocChon,
                  items: DataStore.danhSachChucVu
                      .map((cv) => DropdownMenuItem(
                          value: cv, child: Text(cv.tenChucVu)))
                      .toList(),
                  onChanged: (val) => setState(() => chucVuDuocChon = val),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Xác Nhận Bổ Nhiệm',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (nhanVienDuocChon == null || chucVuDuocChon == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Vui lòng chọn đầy đủ thông tin!')));
                      return;
                    }
                    setState(() =>
                        nhanVienDuocChon!.maChucVu = chucVuDuocChon!.maChucVu);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Đã bổ nhiệm ${chucVuDuocChon!.tenChucVu} cho ${nhanVienDuocChon!.hoTen}!')));
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text('DANH SÁCH NHÂN SỰ HIỆN TẠI',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
          ),
          Expanded(
            child: DataStore.danhSachNhanVien.isEmpty
                ? const Center(child: Text('Không có dữ liệu'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: DataStore.danhSachNhanVien.length,
                    itemBuilder: (ctx, idx) {
                      final nv = DataStore.danhSachNhanVien[idx];
                      var timCV = DataStore.danhSachChucVu
                          .where((cv) => cv.maChucVu == nv.maChucVu);
                      final tenCV = timCV.isNotEmpty
                          ? timCV.first.tenChucVu
                          : 'Chưa phân công';
                      final isAssigned = timCV.isNotEmpty;

                      return Card(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200)),
                        child: ListTile(
                          leading: Icon(
                              isAssigned
                                  ? Icons.verified_user
                                  : Icons.help_outline,
                              color:
                                  isAssigned ? Colors.deepOrange : Colors.grey),
                          title: Text(nv.hoTen,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Chức vụ: $tenCV',
                              style: TextStyle(
                                  color: isAssigned
                                      ? Colors.deepOrange.shade300
                                      : Colors.grey)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
