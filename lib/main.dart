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
          title: 'Quản Lý Nhân Sự Giữa Kỳ',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          themeMode: modeHienTai,
          home: const ManHinhChinh(),
        );
      },
    );
  }
}

class ManHinhChinh extends StatelessWidget {
  const ManHinhChinh({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hệ Thống Quản Lý Nhân Sự'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.corporate_fare, size: 80, color: Colors.blue),
            const SizedBox(height: 12),
            const Text(
              'DANH MỤC QUẢN TRỊ VIÊN',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1),
            ),
            const SizedBox(height: 30),
            _nutMenuGiaoDien(context, Icons.people, 'Quản Lý Nhân Viên',
                const QuanLyNhanVien()),
            _nutMenuGiaoDien(
                context, Icons.badge, 'Quản Lý Chức Vụ', const QuanLyChucVu()),
            _nutMenuGiaoDien(context, Icons.assignment,
                'Gán Chức Vụ Thành Viên', const GanChucVuWidget()),
            _nutMenuGiaoDien(context, Icons.settings, 'Cài Đặt Hệ Thống',
                const CaidatGiaodien()),
          ],
        ),
      ),
    );
  }

  Widget _nutMenuGiaoDien(
      BuildContext context, IconData icon, String tieuDe, Widget manHinhDich) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.centerLeft,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => manHinhDich));
        },
        icon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: Icon(icon, size: 26),
        ),
        label: Text(tieuDe,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
