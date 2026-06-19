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
      appBar: AppBar(title: const Text('Gán Chức Vụ Cho Nhân Viên')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<NhanVien>(
              decoration: const InputDecoration(
                  labelText: 'Chọn Nhân Viên', border: OutlineInputBorder()),
              value: nhanVienDuocChon,
              items: DataStore.danhSachNhanVien.map((nv) {
                return DropdownMenuItem(
                    value: nv, child: Text('${nv.maNV} - ${nv.hoTen}'));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  nhanVienDuocChon = val;
                  if (val?.maChucVu != null) {
                    // Sửa lỗi tìm kiếm an toàn (tránh lỗi trên SDK cũ)
                    var danhSachLoc = DataStore.danhSachChucVu
                        .where((cv) => cv.maChucVu == val!.maChucVu);
                    chucVuDuocChon =
                        danhSachLoc.isNotEmpty ? danhSachLoc.first : null;
                  } else {
                    chucVuDuocChon = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ChucVu>(
              decoration: const InputDecoration(
                  labelText: 'Chọn Chức Vụ Muốn Gán',
                  border: OutlineInputBorder()),
              value: chucVuDuocChon,
              items: DataStore.danhSachChucVu.map((cv) {
                return DropdownMenuItem(
                    value: cv, child: Text('${cv.maChucVu} - ${cv.tenChucVu}'));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  chucVuDuocChon = val;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () {
                if (nhanVienDuocChon == null || chucVuDuocChon == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Vui lòng chọn đầy đủ cả Nhân viên và Chức vụ!')),
                  );
                  return;
                }
                setState(() {
                  nhanVienDuocChon!.maChucVu = chucVuDuocChon!.maChucVu;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Đã cập nhật chức vụ [${chucVuDuocChon!.tenChucVu}] cho [${nhanVienDuocChon!.hoTen}]!')),
                );
              },
              child: const Text('Xác Nhận Lưu Gán Chức Vụ',
                  style: TextStyle(fontSize: 16)),
            ),
            const Divider(height: 40, thickness: 1.5),
            const Text(
              'Danh Sách Điều Động Nhân Sự Hiện Tại:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: DataStore.danhSachNhanVien.isEmpty
                  ? const Center(child: Text('Không có nhân viên nào.'))
                  : ListView.builder(
                      itemCount: DataStore.danhSachNhanVien.length,
                      itemBuilder: (ctx, idx) {
                        final nv = DataStore.danhSachNhanVien[idx];

                        // Sửa lỗi firstOrNull: Kiểm tra an toàn cho Flutlab
                        var timChucVu = DataStore.danhSachChucVu
                            .where((cv) => cv.maChucVu == nv.maChucVu);
                        final tenCV = timChucVu.isNotEmpty
                            ? timChucVu.first.tenChucVu
                            : 'Chưa phân chức vụ (Mới)';

                        return ListTile(
                          leading: const Icon(Icons.assignment_ind,
                              color: Colors.green),
                          title: Text(nv.hoTen,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text('Chức danh: $tenCV',
                              style: TextStyle(
                                  color: nv.maChucVu != null
                                      ? Colors.blue
                                      : Colors.red)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
