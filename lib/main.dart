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
          title: 'HR Manager Pro',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: Colors.grey[100],
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
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

  String _ngayHienTai() {
    DateTime now = DateTime.now();
    return 'Ngày ${now.day} tháng ${now.month}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    int tongNV = DataStore.danhSachNhanVien.length;
    int tongCV = DataStore.danhSachChucVu.length;
    int nvDaPhanCong =
        DataStore.danhSachNhanVien.where((nv) => nv.maChucVu != null).length;
    double tiLePhanCong = tongNV == 0 ? 0 : nvDaPhanCong / tongNV;

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 60, left: 24, right: 24, bottom: 30),
              decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_ngayHienTai(),
                          style: TextStyle(
                              color: Colors.indigo.shade100, fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text(
                        'Xin chào, Admin! 👋',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.admin_panel_settings,
                        color: Colors.indigo.shade400, size: 30),
                  )
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tiến độ phân bổ nhân sự',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('${(tiLePhanCong * 100).toInt()}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: tiLePhanCong,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$nvDaPhanCong/$tongNV nhân viên đã có chức danh',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: const Text('BẢNG ĐIỀU KHIỂN',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Tắt cuộn của Grid để dùng cuộn của trang
                childAspectRatio: 1.1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _taoOChucNang('Nhân Sự', '$tongNV người', Icons.people_alt,
                      Colors.blue, const QuanLyNhanVien()),
                  _taoOChucNang('Chức Vụ', '$tongCV chức danh', Icons.badge,
                      Colors.orange, const QuanLyChucVu()),
                  _taoOChucNang('Bổ Nhiệm', 'Phân công việc', Icons.handshake,
                      Colors.green, const GanChucVuWidget()),
                  _taoOChucNang('Hệ Thống', 'Cài đặt giao diện', Icons.settings,
                      Colors.blueGrey, const CaidatGiaodien()),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('THÊM GẦN ĐÂY',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2)),
                  TextButton(
                    onPressed: () => _chuyenTrang(const QuanLyNhanVien()),
                    child: const Text('Xem tất cả'),
                  )
                ],
              ),
            ),
            DataStore.danhSachNhanVien.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Chưa có nhân viên nào.'))
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: DataStore.danhSachNhanVien.length > 3
                        ? 3
                        : DataStore.danhSachNhanVien.length,
                    itemBuilder: (context, index) {
                      final nv =
                          DataStore.danhSachNhanVien.reversed.toList()[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                color: Colors.grey.withOpacity(0.2))),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade50,
                            child: Text(nv.hoTen[0],
                                style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold)),
                          ),
                          title: Text(nv.hoTen,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(nv.trinhDo),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.grey),
                          onTap: () => _chuyenTrang(const QuanLyNhanVien()),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _taoOChucNang(String tieuDe, String moTa, IconData icon, Color mauSac,
      Widget trangDich) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => _chuyenTrang(trangDich),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: mauSac.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: mauSac, size: 28),
            ),
            const Spacer(),
            Text(tieuDe,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(moTa,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
