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
          title: 'Quản Lý Nhân Sự Pro',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: Colors.grey[50], // Nền xám nhạt sang trọng
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
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
    setState(() {}); // Tải lại số liệu Dashboard
  }

  @override
  Widget build(BuildContext context) {
    int tongNV = DataStore.danhSachNhanVien.length;
    int tongCV = DataStore.danhSachChucVu.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Nhân Sự',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('TỔNG QUAN',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _taoTheThongKe('Nhân Viên', tongNV.toString(),
                        Icons.people_alt_rounded, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(
                    child: _taoTheThongKe('Chức Vụ', tongCV.toString(),
                        Icons.badge_rounded, Colors.orange)),
              ],
            ),
            const SizedBox(height: 32),
            const Text('QUẢN TRỊ HỆ THỐNG',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.5)),
            const SizedBox(height: 12),
            _nutMenuGiaoDien(
                Icons.group_rounded,
                Colors.indigo,
                'Quản Lý Nhân Viên',
                'Thêm, sửa, xóa hồ sơ nhân sự',
                const QuanLyNhanVien()),
            _nutMenuGiaoDien(
                Icons.assignment_ind_rounded,
                Colors.teal,
                'Quản Lý Chức Vụ',
                'Thiết lập danh mục chức danh',
                const QuanLyChucVu()),
            _nutMenuGiaoDien(
                Icons.handshake_rounded,
                Colors.deepOrange,
                'Phân Bổ Chức Vụ',
                'Điều động & bổ nhiệm nhân sự',
                const GanChucVuWidget()),
            _nutMenuGiaoDien(
                Icons.settings_rounded,
                Colors.blueGrey,
                'Cài Đặt Hệ Thống',
                'Tùy chỉnh giao diện Sáng/Tối',
                const CaidatGiaodien()),
          ],
        ),
      ),
    );
  }

  Widget _taoTheThongKe(
      String tieuDe, String giaTri, IconData icon, Color mauSac) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: mauSac.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 30, color: mauSac),
          ),
          const SizedBox(height: 16),
          Text(giaTri,
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(tieuDe,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _nutMenuGiaoDien(IconData icon, Color iconColor, String tieuDe,
      String moTa, Widget manHinhDich) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(tieuDe,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(moTa, style: const TextStyle(fontSize: 13)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () => _chuyenTrang(manHinhDich),
      ),
    );
  }
}
