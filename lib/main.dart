import 'package:flutter/material.dart';
import 'models/data_store.dart';
import 'widgets/quanly_nhanvien.dart';
import 'widgets/quanly_chucvu.dart';
import 'widgets/gan_chucvu.dart';
import 'widgets/caidat_giaodien.dart';

void main() {
  runApp(const HRManagementApp());
}

class HRManagementApp extends StatelessWidget {
  const HRManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: DataStore.themeNotifier,
      builder: (_, ThemeMode modeHienTai, __) {
        return MaterialApp(
          title: 'Quản Lý Nhân Sự VIP',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          themeMode: modeHienTai,
          home: const ManHinhChinh(),
        );
      },
    );
  }
}

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({Key? key}) : super(key: key);

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  void _chuyenTrang(Widget trangDich) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => trangDich));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int tongNV = DataStore.danhSachNhanVien.length;
    int tongCV = DataStore.danhSachChucVu.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hệ Thống Nhân Sự',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- DASHBOARD THỐNG KÊ ---
            const Text('TỔNG QUAN HỆ THỐNG',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: _taoTheThongKe('Nhân Viên', tongNV.toString(),
                        Icons.people, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(
                    child: _taoTheThongKe('Chức Vụ', tongCV.toString(),
                        Icons.badge, Colors.orange)),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),

            // --- MENU QUẢN TRỊ ---
            const Text('CHỨC NĂNG QUẢN TRỊ',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 10),
            _nutMenu(Icons.group, 'Quản Lý Nhân Viên', const QuanLyNhanVien()),
            _nutMenu(
                Icons.assignment_ind, 'Quản Lý Chức Vụ', const QuanLyChucVu()),
            _nutMenu(
                Icons.handshake, 'Phân Bổ Chức Vụ', const GanChucVuWidget()),
            _nutMenu(
                Icons.settings, 'Cài Đặt Giao Diện', const CaidatGiaodien()),
          ],
        ),
      ),
    );
  }

  Widget _taoTheThongKe(
      String tieuDe, String giaTri, IconData icon, Color mauSac) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: mauSac),
            const SizedBox(height: 8),
            Text(giaTri,
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: mauSac)),
            Text(tieuDe,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _nutMenu(IconData icon, String tieuDe, Widget manHinhDich) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.centerLeft,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _chuyenTrang(manHinhDich),
        icon: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8.0),
            child: Icon(icon, size: 26)),
        label: Text(tieuDe,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
